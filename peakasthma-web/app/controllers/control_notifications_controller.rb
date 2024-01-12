class ControlNotificationsController < ApplicationController
  authenticated!
  before_action :redirect_non_admin
  before_action :find_notification, only: [:edit, :update, :destroy]
  before_action :fail_if_already_sent, only: [:edit, :update, :destroy]
  before_action :find_patient, only: [:new, :create, :destroy, :update, :edit]

  def index
    @control_notifications = ControlNotification.where("alert = 9 AND user_id IS NOT NULL").order(sent: :asc, send_at: :desc).paginate(page: params[:page], per_page: 10)
    # @control_notification_stats = notification_stats
  end

  def create
    @control_notification = ControlNotification.new(notification_params)
    @control_notification.author = current_user
    if @control_notification.save
      if @control_patient
        ControlPatientNotificationJob.set(wait_until: @control_notification.send_at).perform_later(@control_notification, @control_patient)
        respond_with @control_notification, location: new_control_patient_control_notification_path
      else
        MassControlPatientNotificationJob.set(wait_until: @control_notification.send_at).perform_later(@control_notification)
        respond_with @control_notification, location: control_notifications_path
      end
      # MassPatientNotificationJob.perform_now(@notification)
    else
      flash[:error] = @control_notification.errors.full_messages.to_sentence
      if @control_patient
        redirect_to new_control_patient_control_notification_path
      else
        redirect_to control_notifications_path
      end
    end
  end

  def edit
  end

  def new
    @control_notifications = ControlNotification.where("alert = 10 and target_patient=#{@control_patient.id}").order(sent: :asc, send_at: :desc).paginate(page: params[:page], per_page: 10)
    @control_notification = ControlNotification.new
  end

  def update
    @new_control_notification = @control_notification.dup
    @new_control_notification.update(notification_params)
    @control_notification.destroy
    if @control_patient
      ControlPatientNotificationJob.set(wait_until: @new_control_notification.send_at).perform_later(@new_control_notification, @control_patient)
      respond_with @new_control_notification, location: new_control_patient_control_notification_path
    else
      MassControlPatientNotificationJob.set(wait_until: @new_control_notification.send_at).perform_later(@new_control_notification)
      respond_with @new_control_notification, location: control_notifications_path
    end
  end

  def destroy
    @control_notification.destroy
    if @control_patient
      respond_with @control_notification, location: new_control_patient_control_notification_path(@control_patient)
    else
      respond_with @control_notification, location: control_notifications_path
    end
  end

  private

    def find_patient
      if params[:control_patient_id]
        @control_patient = ControlPatient.find(params[:control_patient_id])
      end
    end

    def find_notification
      @control_notification = ControlNotification.find(params[:id])
    end

    def notification_params
      valid_params = params.require(:control_notification).permit(:id, :message, :send_at, :alert, :target_patient)
      if valid_params[:send_at]
        valid_params[:send_at] = valid_params[:send_at].to_time
      end

      valid_params
    end

    def fail_if_already_sent
      find_notification
      find_patient
      return unless @control_notification.sent

      flash[:error] = I18n.t 'notification.errors.already_sent'
      
      if @control_notification.alert == 10
        redirect_to new_control_patient_control_notification_path(@control_patient)
      else
        redirect_to control_notifications_path
      end
    end

    def notification_stats
      {
        average_open_rate: calculate_average_open_percentage,
        notifications_sent: calculate_notifications_sent,
        notifications_clicked: ReadControlNotificationRecord.count,
        engagement_rate: calculate_engagement_rate
      }
    end

    def calculate_notifications_sent
      ControlNotification.sent.reduce(0) { |sum, notification| sum += notification.recipients.count }
    end

    def calculate_engagement_rate
      return 0.0 unless ControlNotification.count > 0
      ControlNotification.read.count.to_f / ControlNotification.count.to_f * 100
    end

    def calculate_average_open_percentage
      return 0.0 unless ControlNotification.sent.count > 0
      total = ControlNotification.sent.reduce(0) { |sum, notification| sum += notification.open_rate }
      (total / ControlNotification.sent.count) * 100
    end
end
