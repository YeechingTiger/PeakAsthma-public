class AddFrequencyFormulationToMedication < ActiveRecord::Migration[5.1]
  def change
    rename_column :medications, :medication_type, :route
    add_column :medications, :formulation, :integer
    add_column :prescriptions, :dosage, :integer

    remove_column :prescriptions, :amount, :float
    remove_column :prescriptions, :period, :integer
    remove_column :prescriptions, :unit, :string
  end
end
