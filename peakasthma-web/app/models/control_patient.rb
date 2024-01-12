class ControlPatient < ApplicationRecord
  belongs_to :user
  has_many :control_activities
  has_many :diet_records
  has_many :read_control_notification_records
  has_and_belongs_to_many :control_notifications, join_table: :control_notifications_control_patients

  accepts_nested_attributes_for :user

  scope :created_before, -> (date) { where("created_at < ?", date) }

  validates :birthday, presence: true
  validate  :validate_age
  validates :gender, presence: true
  validates :height, inclusion: { in: 0..90, message: 'The height must be between 0 and 90' }
  validates :phone, format: { with: /\A^[1-9]\d{2}-\d{3}-\d{4}\z/, message: "Please enter phone number in correct format: 123-456-7890"}, presence: true
  validates :redcap_id, presence: true, uniqueness: true

  GENDERS = [:male, :female, :other].freeze
  enum gender: GENDERS

  delegate :first_name, :last_name, :email, :username, :full_name, :disabled, to: :user

  def validate_age
    if birthday.present? && birthday > 12.years.ago.to_date
      errors.add(:birthday, 'The patient should be over 12 years old.')
    elsif birthday.present? && birthday < 21.years.ago.to_date
      errors.add(:birthday, 'The patient should be less than 21 years old.')
    end
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

  def read_notifications
    read_control_notification_records.map(&:control_notification)
  end

  def unread_notifications
    control_notifications.where.not(id: read_notifications.pluck(:id))
  end
end
