class ControlNotification < ApplicationRecord
  belongs_to :user, optional: true
  alias_attribute :author, :user

  has_many :read_control_notification_records, dependent: :destroy
  
  has_and_belongs_to_many :control_patients, join_table: :control_notifications_control_patients
  alias_attribute :recipients, :control_patients

  scope :sent, -> { where(sent: true) }
  scope :read, -> { sent.includes(:read_control_notification_records).where.not(read_control_notification_records: {id: nil}) }

  validates :message, presence: true
  validates :send_at, presence: true

  def open_rate
    if recipients.count > 0
      read_control_notification_records.count.to_f / recipients.count.to_f
    else
      0
    end
  end
end
