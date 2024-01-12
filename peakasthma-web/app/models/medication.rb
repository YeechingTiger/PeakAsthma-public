class Medication < ApplicationRecord
  has_many :prescriptions
  belongs_to :type, class_name: "MedicationType"

  validates :name, presence: true
  validates :type_id, presence: true
end
