class NotificationsController < ApplicationController
  authenticated!
  before_action :redirect_non_admin
  before_action :find_notification, only: [:edit, :update, :destroy]
  before_action :fail_if_already_sent, only: [:edit, :update, :destroy]
  before_action :find_patient, only: [:new, :create, :destroy, :update, :edit]

  def index
    @notifications = Notification.where("alert = 9 AND user_id IS NOT NULL").order(sent: :asc, send_at: :desc).paginate(page: params[:page], per_page: 10)
    # @notification_stats = notification_stats
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.author = current_user
    if @notification.save
      if @patient
        PatientNotificationJob.set(wait_until: @notification.send_at).perform_later(@notification, @patient)
        respond_with @notification, location: new_patient_notification_path
      else
        MassPatientNotificationJob.set(wait_until: @notification.send_at).perform_later(@notification)
        respond_with @notification, location: notifications_path
      end
    else
      flash[:error] = @notification.errors.full_messages.to_sentence
      if @patient
        redirect_to new_patient_notification_path
      else
        redirect_to notifications_path
      end
    end
  end

  def edit
  end

  def new
    @notifications = Notification.where("alert = 10 and target_patient=#{@patient.id}").order(sent: :asc, send_at: :desc).paginate(page: params[:page], per_page: 10)
    @notification = Notification.new
  end

  def update
    @new_notification = @notification.dup
    @new_notification.update(notification_params)
    @notification.destroy
    if @patient
      PatientNotificationJob.set(wait_until: @new_notification.send_at).perform_later(@new_notification, @patient)
      respond_with @new_notification, location: new_patient_notification_path
    else
      MassPatientNotificationJob.set(wait_until: @new_notification.send_at).perform_later(@new_notification)
      respond_with @new_notification, location: notifications_path
    end
  end

  def destroy
    @notification.destroy
    if @patient
      respond_with @notification, location: new_patient_notification_path
    else
      respond_with @notification, location: notifications_path
    end
  end

  def fields
    render 'notifications/_fields', locals: { type: selected_type[:id] }, layout: false
  end
  
  private
    def selected_type
      params.require(:dynamic_view)
    end

    def find_patient
      if params[:patient_id]
        @patient = Patient.find(params[:patient_id])
      end
    end

    def find_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      valid_params = params.require(:notification).permit(:id, :message, :send_at, :alert, :tip_flag, :target_patient)
      if valid_params[:send_at]
        valid_params[:send_at] = valid_params[:send_at].to_time
      end

      valid_params
    end

    def fail_if_already_sent
      find_notification
      find_patient
      return unless @notification.sent

      flash[:error] = I18n.t 'notification.errors.already_sent'

      if @notification.alert == 10
        redirect_to new_patient_notification_path(@patient)
      else
        redirect_to notifications_path
      end
    end

    def notification_stats
      {
        average_open_rate: calculate_average_open_percentage,
        notifications_sent: calculate_notifications_sent,
        notifications_clicked: ReadNotificationRecord.count,
        engagement_rate: calculate_engagement_rate
      }
    end

    def calculate_notifications_sent
      Notification.sent.reduce(0) { |sum, notification| sum += notification.recipients.count }
    end

    def calculate_engagement_rate
      return 0.0 unless Notification.count > 0
      Notification.read.count.to_f / Notification.count.to_f * 100
    end

    def calculate_average_open_percentage
      return 0.0 unless Notification.sent.count > 0
      total = Notification.sent.reduce(0) { |sum, notification| sum += notification.open_rate }
      (total / Notification.sent.count) * 100
    end
end
