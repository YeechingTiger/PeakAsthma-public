class PeakFlow < ApplicationRecord
  include ActivityFeed

  belongs_to :patient
  has_and_belongs_to_many :symptoms

  scope :with_score, -> { where.not(score: nil) }
  scope :older_than, -> (time) { where("created_at >= ?", time.ago) }

  LEVELS = [:green, :yellow, :red, :red_now].freeze

  EXACERBATION_ZONE_TIMEFRAME = {
    yellow: 48,
    red: 1
  }

  after_create :check_in_with_patient

  def level
    if score.present?
      level_by_score
    else
      level_by_symptoms
    end
  end

  def prev
    patient.peak_flows.where("created_at < ?", created_at).order("created_at ASC").last
  end

  private
    def red_now(symptoms)
      red_em_symptoms = Symptom.where(emergency: true)
      for symtom in red_em_symptoms
        if symptoms.where(name: symtom.name).any?
          return :red_now
        end
      end 
      return :red
    end


    def level_by_score
      if score > patient.yellow_zone_maximum
        :green
      elsif score >= patient.yellow_zone_minimum
        :yellow
      else
        :red
      end
    end

    def level_by_symptoms
      if symptoms.where(level: :red).any?
        red_now(symptoms)
      elsif symptoms.where(level: :yellow).any?
        :yellow
      else
        :green
      end
    end

    def check_in_with_patient
      # If an old notification exists, destroy it and create a new one for it.
      @current_time = DateTime.current
      @old_notification = Notification.where("alert = 2 AND user_id = ? AND send_at > ?", self.patient.user, @current_time).order("created_at ASC").last
      @notification_exacerbation = I18n.t("patient.notifications.#{level}_exacerbation")
      @wait_time = EXACERBATION_ZONE_TIMEFRAME[level].hours if level == :yellow || level == :red
      if level == :green
        @old_notification.destroy if @old_notification
      elsif level == :red_now
        @old_notification.destroy if @old_notification
        send_peak_flow_notification_now(self, @notification_exacerbation, @current_time)
      elsif prev&.level == level
        case level
        when :yellow
          if @old_notification
            if(@old_notification.send_at - @current_time) < 24.hours
              @old_notification.destroy
              send_peak_flow_notification_now(self, @notification_exacerbation, @current_time)
            end
          else
            send_peak_flow_notification_later(self, @notification_exacerbation, @current_time, @wait_time)
          end
        when :red
          if @old_notification
            @old_notification.destroy
            send_peak_flow_notification_now(self, @notification_exacerbation, @current_time)
          else
            send_peak_flow_notification_later(self, @notification_exacerbation, @current_time, @wait_time)
          end
        end
        
      else
        @old_notification.destroy if @old_notification
        send_peak_flow_notification_later(self, @notification_exacerbation, @current_time, @wait_time)
      end
    end

    def send_peak_flow_notification_now(peak_flow, notification_exacerbation, current_time)
      @notification = create_peak_flow_notification(peak_flow, notification_exacerbation, current_time )
      PeakFlowNotificationJob.perform_now(peak_flow, @notification)
    end

    def send_peak_flow_notification_later(peak_flow, notification_exacerbation, current_time ,wait_time)
      @notification = create_peak_flow_notification(peak_flow, notification_exacerbation, current_time + wait_time)
      puts @notification.inspect
      PeakFlowNotificationJob.set(wait: wait_time).perform_later(peak_flow, @notification)
    end

    def create_peak_flow_notification(peak_flow, message, time)
      @Notification = Notification.create(
        user: peak_flow.patient.user,
        message: message,
        alert: 2,
        send_at: time)
      
      @Notification
    end
end
