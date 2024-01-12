require 'will_paginate/array'
class PatientsController < ApplicationController
  authenticated!
  before_action :redirect_wrong_patient
  before_action :find_patient, only: [:show, :edit, :update]

  def index
    if params[:search].blank?
      @patients = Patient.all.order(updated_at: :desc).paginate(page: params[:page])
    else
      @parameter = params[:search].downcase
      @patients = Patient.joins(:user).all.where("lower(CONCAT(users.first_name, ' ', users.last_name)) LIKE :search", search: "%#{@parameter}%").order(updated_at: :desc).paginate(page: params[:page])
    end

  end

  def update
    @patient.update(patient_params)
    respond_with @patient
  end

  def show
    # @exacerbations = Exacerbation.where("patient_id = ?", @patient.id).order(created_at: :desc).paginate(page: params[:exacerbations_page], per_page: 6)
    @exacerbations = Exacerbation.where('patient_id = ?', @patient.id)
                                 .select('"exacerbations".*, "ahoy_messages".opened_at')
                                 .joins('LEFT JOIN ahoy_messages ON exacerbations.id = ahoy_messages.exacerbation_id AND ahoy_messages.user_id != 1 and ahoy_messages.user_id IS NOT NULL')
                                 .order(created_at: :desc)
                                 .paginate(page: params[:exacerbations_page], per_page: 6)
    @exacerbations.inspect
    @refill_record = PrescriptionRefillRecord.where("patient_id = ?", @patient.id).order(created_at: :desc).paginate(page: params[:refill_page], per_page: 12)
    @incentives
    @month_incentives = 0
    @total_incentives = []
    @all_incentives = []
    @days = days_after_enroll()
    @months = @days / 30 + 1
    @monthly_rewards_days = Hash.new
    for i in (1..@months)
      @monthly_rewards_days[i] = 0
    end

    @all_incentives = IncentiveRecord.where(patient_id: params[:id]).order(month: :asc, week: :asc, day: :asc)
    @all_incentives = @all_incentives.to_a
    @all_incentives.each_with_index do |incentive, index|
      total_days = (incentive.week - 1) * 7 + incentive.day
      true_month = (total_days - 1) / 30 + 1
      if @monthly_rewards_days.include?(true_month) and @monthly_rewards_days[true_month] >= 20
        @all_incentives[index].get_incentive = false
      else
        @all_incentives[index].get_incentive = true
        @monthly_rewards_days[true_month] += 1
      end 
      @all_incentives[index]['month'] = true_month
      @all_incentives[index]['day'] = total_days - 30 * (true_month-1)
    end
    @incentives =  @all_incentives.paginate(page: params[:incentives_page], per_page: 5)
    @len = @monthly_rewards_days.length - 1
    if @len >= 0
      @month_incentives = @monthly_rewards_days.values[@len]
      last_month = @monthly_rewards_days.keys[@len]
      @monthly_rewards_days.delete(last_month)
    else
      @month_incentives = 0
      last_month = 0
    end
    @total_incentives = @all_incentives.select do |elem|
      elem.get_incentive == true
    end

    @prescription_history = Prescription.where("patient_id = ?", @patient.id).order(id: :desc).paginate(page: params[:page])

    twilio_phone_call_status
  end

  def edit
    fill_redcap_data(@patient, params['import-redcap-id'])
  end

  def new
    @patient = Patient.new
    @patient.user = User.new
    fill_redcap_data(@patient, params['import-redcap-id'])
  end

  def create
    @patient = Patient.create(patient_params)
    respond_with @patient
  end

  private
    def patient_params
      valid_params = params.require(:patient).permit(
        :yellow_zone_maximum,
        :yellow_zone_minimum,
        :medication_reminders,
        :medication_reminder_time,
        :report_reminder_time,
        :gender,
        :birthday,
        :height,
        :weight,
        :phone, 
        :physician,
        :remind_later_time,
        :time,
        :redcap_id,
        user_attributes: [:id, :first_name, :last_name, :username, :email, :role, :disabled])
  
        if valid_params[:medication_reminder_time]
          valid_params[:medication_reminder_time] = valid_params[:medication_reminder_time].to_time
        end

        if valid_params[:report_reminder_time]
          valid_params[:report_reminder_time] = valid_params[:report_reminder_time].to_time
        end

        valid_params[:user_attributes][:encrypted_password] = '$2a$11$cixW0odcieVc4XgCQ.mu.evLbsvuR/6aqANX/8Sup8EXPU/gkDNP6' if action_name == 'create'

        valid_params
    end

    def find_patient
      @patient = Patient.find(params[:id])
      @patient
    end

    def days_after_enroll()
      @enroll_date = @patient.created_at.to_date
      @current_date = Time.now.utc.to_date
      @days = @current_date - @enroll_date
      @days = @days.to_i
    end

    def day
        @days = days_after_enroll()
        @week_day = (@days % 7) + 1
    end

    def week
        @days = days_after_enroll()
        @week = (@days / 7) + 1
    end

    def month
        @month = ((week - 1) / 4) + 1 
    end

    def fill_redcap_data(patient, redcap_id)
      info = RedcapAPI.get_patient_demographic_info(redcap_id)

      patient.birthday = info[:dob] if info[:dob] != nil
      patient.gender = info[:gender] if info[:gender] != nil
      patient.physician = info[:pcp] if info[:pcp] != nil
      patient.height = info[:height] if info[:height] != nil
      patient.weight = info[:weight] if info[:weight] != nil
      patient.redcap_id = redcap_id if redcap_id != nil

      patient.user.first_name = info[:first_name] if info[:first_name] != nil
      patient.user.last_name = info[:last_name] if info[:last_name] != nil
    end

    def twilio_phone_call_status
      account_sid = Rails.application.secrets.twilio_sid
      auth_token = Rails.application.secrets.twilio_token
      @client = Twilio::REST::Client.new account_sid, auth_token
      calls = @client.calls.list()
      @exacerbation_phone_call_status_dict = Hash.new
      @exacerbation_phone_calls = TwilioPhoneCall.all
      
      for exacerbation_phone_call in @exacerbation_phone_calls
        
        call = calls.select { |call| call.sid == exacerbation_phone_call.twilio_sid }
        if call[0].present?
            @exacerbation_phone_call_status_dict[exacerbation_phone_call.exacerbation_id] = call[0].status
        end
      end
    end
end
