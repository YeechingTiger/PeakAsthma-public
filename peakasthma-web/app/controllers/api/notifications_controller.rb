module API
  class NotificationsController < API::BaseController
    authenticated!

    def index
      @notifications = current_user.patient.notifications
      if params[:unread]
        @notifications = current_user.patient.unread_notifications
      elsif params[:read]
        @notifications = current_user.patient.read_notifications
      end
      puts "--------------Notification Count----------------------"
      puts @notifications.count()
      respond_with @notifications
    end
  end
end
