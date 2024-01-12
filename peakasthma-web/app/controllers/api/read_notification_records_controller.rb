module API
  class ReadNotificationRecordsController < API::BaseController
    authenticated!

    def create
      notification = Notification.find(params[:id])
      @read_notification_record = ReadNotificationRecord.find_or_create_by(patient: current_user.patient, notification: notification)
      respond_with @read_notification_record
    end
  end
end
