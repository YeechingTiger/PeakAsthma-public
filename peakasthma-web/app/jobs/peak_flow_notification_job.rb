class PeakFlowNotificationJob < PatientNotificationJob
  queue_as :default

  def perform(peak_flow, notification)
    return unless notification

    if (peak_flow)
      # Peak flow notifications are only valid if they are the last reported flow.
      # This catches the case for all cases in which we'd want to send a notification.
      @exacerbation = Exacerbation.create(
        patient: peak_flow.patient,
        exacerbation: peak_flow.level,
        status: 1,
        comment: ""
        )

      notification.patients = [ peak_flow.patient ]
      if peak_flow.level == :yellow
        for guardian in peak_flow.patient.guardians
          PatientExacerbationMailer.yellow_patient_exacerbation_email(guardian, @exacerbation.id).try(:deliver_later)
        end
          PatientExacerbationMailer.yellow_patient_exacerbation_email_admin(@exacerbation.id).try(:deliver_later)
      elsif peak_flow.level == :red || peak_flow.level == :red_now
        for guardian in peak_flow.patient.guardians
          PatientExacerbationMailer.red_patient_exacerbation_email(guardian, @exacerbation.id).try(:deliver_later)
        end
          PatientExacerbationMailer.red_patient_exacerbation_email_admin(@exacerbation.id).try(:deliver_later)
      end
      TwilioNotificationJob.perform_later(peak_flow, peak_flow.patient, @exacerbation)
    end
    if notification
      super(notification, peak_flow.patient)
    end
  end
end
