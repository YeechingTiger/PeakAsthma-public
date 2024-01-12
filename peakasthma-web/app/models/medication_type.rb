class MedicationType < ApplicationRecord
  has_many :medications

  TYPES = {
    controller: 'Controller',
    rescue: 'Rescue',
    other: 'Other'
  }.freeze
  ALL_TYPES = TYPES.values.freeze

  validates :kind, presence: true
end
