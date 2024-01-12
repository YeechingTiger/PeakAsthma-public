class LevelType < ApplicationRecord
  has_many :prescription_levels
  has_many :prescriptions, through: :prescription_levels

  LEVELS = {
    green: 'Green',
    yellow: 'Yellow',
    red: 'Red'
  }.freeze
  ALL_LEVELS = LEVELS.values.freeze

  validates :kind, presence: true
end
