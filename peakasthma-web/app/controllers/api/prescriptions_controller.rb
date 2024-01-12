module API
  class PrescriptionsController < API::BaseController
    authenticated!

    def index 
      prescriptions = current_user.patient.prescriptions.where(valid_status: true)
      respond_with prescriptions
    end

    def notifications
      current_user.patient.update(notification_pref_update_params)
      respond_with current_user
    end

    def reports
      current_user.patient.update(report_notification_pref_update_params)
      respond_with current_user
    end

    def remindmelater
      current_user.patient.update(notification_remind_later_update_params)
      respond_with current_user
    end

    private
      def notification_pref_update_params
        params.permit(:medication_reminders, :medication_reminder_time)
      end

      def report_notification_pref_update_params
        params.permit(:report_reminder_time)
      end

      def notification_remind_later_update_params
        params.permit(:remind_later_time)
      end
  end
end
