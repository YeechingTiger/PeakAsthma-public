class FormulationType < ApplicationRecord
  has_many :prescriptions
  accepts_nested_attributes_for :prescriptions

  FORMULATIONS = {
    suspension_syrup: 'Suspension/Syrup',
    tablet_pill: 'Tablet/Pill',
    inhaled_puffs: 'Inhaled Puffs',
    inhaled_vials: 'Inhaled Solution- # of vials',
    injection: 'Injection'
  }.freeze
  ALL_FORMULATIONS = FORMULATIONS.values.freeze

  validates :kind, presence: true
end
