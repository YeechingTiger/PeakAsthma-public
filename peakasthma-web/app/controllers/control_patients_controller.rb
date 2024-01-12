require 'will_paginate/array'

class ControlPatientsController < ApplicationController
  authenticated!
  before_action :redirect_wrong_patient
  before_action :find_patient, only: [:show, :edit, :update]

  def index
    if params[:search].blank?
      @controlPatients = ControlPatient.all.order(updated_at: :desc).paginate(page: params[:page])
    else
      @parameter = params[:search].downcase
      @controlPatients = ControlPatient.joins(:user).where("lower(CONCAT(users.first_name, ' ', users.last_name)) LIKE :search", search: "%#{@parameter}%").order(updated_at: :desc).paginate(page: params[:page])
    end
    
  end

  def update
    @controlPatient.update(patient_params)
    respond_with @controlPatient
  end

  def show
    # @week_incentives = ControlIncentiveRecord.where(control_patient_id: params[:id], month: month, week: week, get_incentive: true)
    # @total_incentives = ControlIncentiveRecord.where(control_patient_id: params[:id], get_incentive: true)
    @diet_records = DietRecord.where("control_patient_id = ?", @controlPatient.id).order(record_date: :desc).paginate(page: params[:diet_records_page], per_page: 6)
    
    @days = days_after_enroll()
    @months = @days / 30 + 1
    @monthly_rewards_days = Hash.new
    for i in (1..@months)
      @monthly_rewards_days[i] = 0
    end
    
    @all_incentives = ControlIncentiveRecord.where(control_patient_id: params[:id]).order(month: :asc, week: :asc, day: :asc)
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

  end

  def edit
    fill_redcap_data(@controlPatient, params['import-redcap-id'])
  end

  def new
    @controlPatient = ControlPatient.new
    @controlPatient.user = User.new
    fill_redcap_data(@controlPatient, params['import-redcap-id'])
  end

  def create
    @controlPatient = ControlPatient.create(patient_params)
    respond_with @controlPatient
  end

  private
    def patient_params
      valid_params = params.require(:control_patient).permit(
        :daily_reminders,
        :daily_reminder_time,
        :gender,
        :birthday,
        :height,
        :weight,
        :phone, 
        :physician,
        :redcap_id,
        user_attributes: [:id, :first_name, :last_name, :username, :email, :role, :disabled])
  
        if valid_params[:daily_reminder_time]
          valid_params[:daily_reminder_time] = valid_params[:daily_reminder_time].to_time
        end

        valid_params[:user_attributes][:encrypted_password] = '$2a$11$cixW0odcieVc4XgCQ.mu.evLbsvuR/6aqANX/8Sup8EXPU/gkDNP6' if action_name == 'create'

        valid_params
    end

    def find_patient
      @controlPatient = ControlPatient.find(params[:id])
      @controlPatient
    end

    def days_after_enroll()
      @enroll_date = @controlPatient.created_at.to_date
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

    def fill_redcap_data(control_patient, redcap_id)
      info = RedcapAPI.get_patient_demographic_info(redcap_id)

      control_patient.birthday = info[:dob] if info[:dob] != nil
      control_patient.gender = info[:gender] if info[:gender] != nil
      control_patient.physician = info[:pcp] if info[:pcp] != nil
      control_patient.height = info[:height] if info[:height] != nil
      control_patient.weight = info[:weight] if info[:weight] != nil
      control_patient.redcap_id = redcap_id if redcap_id != nil

      control_patient.user.first_name = info[:first_name] if info[:first_name] != nil
      control_patient.user.last_name = info[:last_name] if info[:last_name] != nil
    end
end
