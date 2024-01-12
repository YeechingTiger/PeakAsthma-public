module API::Control
  class ControlSurveyController < API::Control::BaseController
    authenticated!
    
    def survey
      @patient_id = current_user.control_patient.id
      @patient_reward_record = ControlPatientRewardRecord.where("control_patient_id=?", @patient_id).order(logging_over_day: :desc).first
      if @patient_reward_record != nil
        survey_start_date = @patient_reward_record.logging_over_day
        survey_completion = RedcapAPI.get_patient_monthly_survey(current_user.control_patient.redcap_id, @patient_reward_record.month)
        if survey_completion != nil
          respond_to do |format| 
            format.json { render json: {survey_complete: true, survey_start_date: survey_start_date} }
          end
        else
          link = RedcapAPI.get_survey_link(current_user.control_patient.redcap_id, @patient_reward_record.month)
          payment = @patient_reward_record.payment_amount
          respond_to do |format| 
            format.json { render json: {survey_complete: false, survey_link: link, payment: payment, survey_start_date: survey_start_date} }
          end
        end
      else
        respond_to do |format| 
          format.json { render json: {survey_complete: true, survey_start_date: current_user.patient.created_at} }
        end
      end
    end
  end
end
