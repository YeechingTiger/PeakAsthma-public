class PrescriptionLevel < ApplicationRecord
  belongs_to :prescriptions, optional: true
  belongs_to :level_types, optional: true

  validates :prescription_id, presence: true
  validates :level_id, presence: true
end