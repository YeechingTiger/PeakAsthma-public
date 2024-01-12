class Symptom < ApplicationRecord
  has_and_belongs_to_many :medications
  has_and_belongs_to_many :peak_flows

  enum level: PeakFlow::LEVELS

  validates :name, presence: true
  validates :level, presence: true
  validates :category, presence: false
  validates :emergency, presence: false
end
