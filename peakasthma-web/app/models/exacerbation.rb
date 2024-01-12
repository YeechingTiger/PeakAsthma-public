class Exacerbation < ApplicationRecord
  belongs_to :patient
  has_one :twilio_phone_call

  validates :patient_id, presence: true
  validates :exacerbation, presence: true
  validates :status, presence: true

end
