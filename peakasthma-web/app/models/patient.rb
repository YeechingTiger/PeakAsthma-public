class Patient < ApplicationRecord
  after_initialize :set_default_zone_minimums

  belongs_to :user
  has_many :guardians
  has_many :prescriptions
  has_many :symptom_reports
  has_many :peak_flows
  has_many :activities
  has_many :read_notification_records
  has_many :taken_prescription_records
  has_many :prescription_refill_records
  has_many :clincard_balance_requests
  has_and_belongs_to_many :videos
  has_and_belongs_to_many :notifications

  accepts_nested_attributes_for :user

  scope :created_before, -> (date) { where("created_at < ?", date) }

  validates :birthday, presence: true
  validate :validate_age
  validates :gender, presence: true
  validates :height, inclusion: { in: 0..90, message: 'The height must be between 0 and 90' }
  validates :yellow_zone_minimum, inclusion: { in: 60..800, message: 'The yellow zone minimum peakflow value should be between 60 and 800' }
  validates :yellow_zone_maximum, inclusion: { in: 60..800, message: 'The yellow zone maximum peakflow value should be between 60 and 800' }
  validate :validate_zone_value 
  validates :phone, format: { with: /\A^[1-9]\d{2}-\d{3}-\d{4}\z/, message: "Please enter phone number in correct format: 123-456-7890"}, presence: true
  validates :redcap_id, presence: true, uniqueness: true

  GENDERS = [:male, :female, :other].freeze
  enum gender: GENDERS

  DEFAULT_YELLOW_ZONE_MINIMUM = 170
  DEFAULT_YELLOW_ZONE_MAXIMUM = 220

  delegate :first_name, :last_name, :email, :username, :full_name, :disabled, to: :user

  def validate_age
    if birthday.present? && birthday > 12.years.ago.to_date
      errors.add(:birthday, 'The patient should be over 12 years old.')
    elsif birthday.present? && birthday < 21.years.ago.to_date
      errors.add(:birthday, 'The patient should be less than 21 years old.')
    end
  end

  def validate_zone_value
    if yellow_zone_maximum.present? && yellow_zone_minimum.present? && yellow_zone_maximum <= yellow_zone_minimum
      errors.add(:yellow_zone_maximum, 'The yellow zone maximum peakflow value should be larger than the yellow zone minimum peakflow value')
    end
  end

  def self.in_zone(zone)
    Patient.select { |patient| patient.level == zone }
  end

  def self.app_usage_percentage
    return 0.0 if count == 0

    total_patients = count
    recently_updated_patients = select { |patient| patient.peak_flows.older_than(1.days).any? }.count
    100 * (recently_updated_patients.to_f / total_patients.to_f)
  end

  def level
    peak_flows&.last&.level
  end

  def zone_percentage(target_level)
    return 0 unless peak_flows.any?

    total_time = Time.current - peak_flows.order(created_at: :asc).first.created_at
    target_zone_time = time_in_level(target_level)

    total_time > 0 ? (100 * target_zone_time / total_time).round : 0
  end

  def height_in_feet
    return I18n.t('common.values.n_a') unless height
    feet = height / 12
    inches = height % 12
    "#{feet}\' #{inches}\""
  end

  def weight_in_pounds
    return I18n.t('common.values.n_a') unless weight
    "#{weight.round(2)} lbs"
  end

  def green_zone_range
    I18n.t('patient.views.labels.green_zone_range', max_flow: yellow_zone_maximum, min_flow: yellow_zone_minimum)
  end

  def yellow_zone_range
    I18n.t('patient.views.labels.yellow_zone_range', max_flow: yellow_zone_maximum, min_flow: yellow_zone_minimum)
  end

  def red_zone_range
    I18n.t('patient.views.labels.red_zone_range', max_flow: yellow_zone_maximum, min_flow: yellow_zone_minimum)
  end

  def read_notifications
    read_notification_records.map(&:notification)
  end

  def unread_notifications
    notifications.where.not(id: read_notifications.pluck(:id))
  end

  def recommended_prescription_for_level(level)
    if level == :red_now
      level = :red
    end
    for prescription in prescriptions
      for prescription_level in prescription.prescription_levels
        if(LevelType.find(prescription_level.level_id).kind.downcase.to_s == level.to_s)
          return prescription 
        end
      end
    end
    return nil
  end

  def reports
    reports = []
    report_count = 0
    enroll_date = Date.parse(created_at.to_s)

    until (enroll_date + (report_count + 1) * 30) > Date.today() do
      report = {
        start: enroll_date + report_count * 30,
        end: (enroll_date + (report_count + 1) * 30) - 1,
        report_id: report_count + 1
      }
      reports << report

      report_count += 1
    end

    return reports.reverse
  end

  private
    def set_default_zone_minimums
      self.yellow_zone_minimum ||= DEFAULT_YELLOW_ZONE_MINIMUM
      self.yellow_zone_maximum ||= DEFAULT_YELLOW_ZONE_MAXIMUM
    end

    def time_in_level(target_level)
      target_zone_time = 0
      sorted_peak_flows = peak_flows.order(created_at: :asc)

      sorted_peak_flows.each_with_index do |peak_flow, index|
        time_to_next_entry = sorted_peak_flows[index + 1]&.created_at || Time.current
        target_zone_time += time_to_next_entry - peak_flow.created_at if peak_flow.level == target_level
      end

      target_zone_time
    end
end
