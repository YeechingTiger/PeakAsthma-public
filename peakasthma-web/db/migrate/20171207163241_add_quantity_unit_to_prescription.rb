class AddQuantityUnitToPrescription < ActiveRecord::Migration[5.1]
  def change
    rename_column :prescriptions, :dosage, :quantity
    add_column :prescriptions, :unit, :integer
    add_column :prescriptions, :level, :integer
  end
end
