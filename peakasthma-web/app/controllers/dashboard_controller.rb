class DashboardController < ApplicationController
  authenticated!

  def root
    # Get phone call status
    twilio_phone_call_status

    @patient = current_user.patient
    if @patient
      @exacerbations = Exacerbation.select('"exacerbations".*, "ahoy_messages".opened_at').joins('LEFT JOIN ahoy_messages ON exacerbations.id = ahoy_messages.exacerbation_id AND ahoy_messages.user_id != 1 and ahoy_messages.user_id IS NOT NULL').where('exacerbations.patient_id = ?', @patient.id).order(created_at: :desc).paginate(page: params[:exacerbations_page], per_page: 10)
    end
    root_page = false
    render template: 'patients/show' if current_user.patient?

    @guardian = current_user.guardian
    if @guardian
      @patient = @guardian.patient
      @exacerbations = Exacerbation.select('"exacerbations".*, "ahoy_messages".opened_at').joins('LEFT JOIN ahoy_messages ON exacerbations.id = ahoy_messages.exacerbation_id AND ahoy_messages.user_id != 1 and ahoy_messages.user_id IS NOT NULL').where('exacerbations.patient_id = ?', @patient.id).order(created_at: :desc).paginate(page: params[:exacerbations_page], per_page: 10)
    end
    root_page = false
    render template: 'patients/show' if current_user.guardian?

    @controlPatient = current_user.control_patient
    if @controlPatient
      @diet_records = DietRecord.where("control_patient_id = ?", @controlPatient.id).order(record_date: :desc).paginate(page: params[:diet_records_page], per_page: 6)
    end
    root_page = false
    render template: 'control_patients/show' if current_user.control_patient?

    @patients = Patient.order(updated_at: :desc).limit(10)
    # @exacerbations = Exacerbation.all.order(created_at: :desc).paginate(page: params[:exacerbations_page], per_page: 10)
    @exacerbations = Exacerbation.select('"exacerbations".*, "ahoy_messages".opened_at').joins('LEFT JOIN ahoy_messages ON exacerbations.id = ahoy_messages.exacerbation_id AND ahoy_messages.user_id != 1 and ahoy_messages.user_id IS NOT NULL').order(created_at: :desc).paginate(page: params[:exacerbations_page], per_page: 10)
    @green_zone_percentage = percentage_for_zone(:green)
    @yellow_zone_percentage = percentage_for_zone(:yellow)
    @red_zone_percentage = percentage_for_zone(:red)
    @app_usage_percentage = Patient.app_usage_percentage
    @alert_tables = AlertTable.all.order(created_at: :desc).paginate(page: params[:alert_table_page], per_page: 10)
  end

  private
    def percentage_for_zone(zone = nil)
      patients_total = Patient.count
      return 0.0 if patients_total == 0

      Patient.in_zone(zone).count.to_f / patients_total.to_f * 100.0
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
