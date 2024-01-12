module API::Control
  class ReadNotificationRecordsController < API::Control::BaseController
    authenticated!

    def create
      control_notification = ControlNotification.find(params[:id])
      @read_control_notification_record = ReadControlNotificationRecord.find_or_create_by(control_patient: current_user.control_patient, control_notification: control_notification)
      respond_with @read_control_notification_record
    end
  end
end
