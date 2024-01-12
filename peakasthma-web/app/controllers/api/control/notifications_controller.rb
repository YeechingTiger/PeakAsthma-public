module API::Control
  class NotificationsController < API::Control::BaseController
    authenticated!

    def index
      # MedicationReminderNotificationJob.perform_later()
      # PrescriptionReminderNotificationJob.set(wait: 10.seconds).perform_later()
      @control_notifications = current_user.control_patient.control_notifications
    
      if params[:unread]
        @control_notifications = current_user.control_patient.unread_notifications
      elsif params[:read]
        @control_notifications = current_user.control_patient.read_notifications
      end
      # puts '-----------------------------------------------------'
      # puts warden.session['unique_session_id']
      # puts current_user.unique_session_id
      # puts '-----------------------------------------------------'

      respond_with @control_notifications
    end

    def daily_reminder
      current_user.control_patient.update(daily_reminder_pref_update_params)
      respond_with current_user
    end

  private
    def daily_reminder_pref_update_params
      params.permit(:daily_reminders, :daily_reminder_time)
    end
  end
end
