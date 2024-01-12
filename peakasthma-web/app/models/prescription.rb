class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :prescriber, class_name: "User"
  belongs_to :medication
  belongs_to :formulation, class_name: "FormulationType"
  belongs_to :frequency, class_name: "FrequencyType"
  belongs_to :unit, class_name: "UnitType"
  has_many :prescription_levels
  has_many :level_types, through: :prescription_levels
  has_many :prescription_refill_records
  
  DOSAGE = {
    FormulationType::FORMULATIONS[:suspension_syrup] => ['ml', 'tsp'],
    FormulationType::FORMULATIONS[:tablet_pill] => ['1', '2', 'pack'],
    FormulationType::FORMULATIONS[:inhaled_puffs] => ['1', '2', '3', '4', '5', '6', '7', '8'],
    FormulationType::FORMULATIONS[:inhaled_vials] => ['1', '2', '3'],
    FormulationType::FORMULATIONS[:injection] => ['1']
  }

  DATE_LIST = Array(1..31).map{ |t| "#{t.to_s}" }

  enum reminder_day: DATE_LIST

  validates :frequency_id, presence: true
  validates :unit_id, presence: true
  validates :formulation_id, presence: true
  validates :quantity, presence: true
  validates :medication_id, presence: true
  validates :patient_id, presence: true
  # validates :reminder_day, presence: true

  def dosage
    # translated_formulation = I18n.t("prescription.model.units.#{formulation}")
    # "#{quantity} #{translated_formulation}"
    "#{quantity} #{unit.kind}"
  end

  def level_names
    output = ""
    PrescriptionLevel.where("prescription_id = ?", id).find_each do |pl|
      output << LevelType::ALL_LEVELS[pl.level_id - 1] << ', '
    end
    output.chop.chop
  end

  def level_numbers
    output = []
    PrescriptionLevel.where("prescription_id = ?", id).find_each do |pl|
      output << pl.level_id
    end
    output
  end
end
