class ChangeDataTypeForConfirmedChangedPrescriptions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :confirmed_changed_prescriptions, :medication
    add_reference :confirmed_changed_prescriptions, :medication, foreign_key: {to_table: :medications}, null: false

    remove_reference :confirmed_changed_prescriptions, :prescriber
    add_reference :confirmed_changed_prescriptions, :prescriber, foreign_key: {to_table: :users}, null: false

    remove_reference :confirmed_changed_prescriptions, :patient
    add_reference :confirmed_changed_prescriptions, :patient, foreign_key: {to_table: :patients}, null: false
  end
end
