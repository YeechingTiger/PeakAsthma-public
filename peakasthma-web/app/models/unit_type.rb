class UnitType < ApplicationRecord
  has_many :prescriptions
  accepts_nested_attributes_for :prescriptions

  UNITS = {
    FormulationType::FORMULATIONS[:suspension_syrup] => {
      ml: 'ml',
      tsp: 'tsp'
    },
    FormulationType::FORMULATIONS[:tablet_pill] => {
      tablet_pill: 'Tablet/Pill',
      pack: 'Pack(s)'
    },
    FormulationType::FORMULATIONS[:inhaled_puffs] => {
      puffs: 'Puff(s)'
    },
    FormulationType::FORMULATIONS[:inhaled_vials] => {
      vials: 'Vial(s)'
    },
    FormulationType::FORMULATIONS[:injection] => {
      injection: 'Injection'
    }
  }.freeze

  all_units = []
  UNITS.values.each do |v|
    all_units += v.values
  end
  ALL_UNITS = all_units.freeze

  validates :kind, presence: true
end
