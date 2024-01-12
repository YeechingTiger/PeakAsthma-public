class ChangePresciptionsColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :formulation_types do |t|
      t.string :kind, null: false
    end

    create_table :frequency_types do |t|
      t.string :kind, null: false
    end

    create_table :unit_types do |t|
      t.string :kind, null: false
    end

    remove_column :prescriptions, :level, :integer

    add_foreign_key :prescriptions, :medications, column: :medication_id
    change_column_null :prescriptions, :medication_id, false

    add_foreign_key :prescriptions, :users, column: :prescriber_id
    change_column_null :prescriptions, :prescriber_id, false

    add_foreign_key :prescriptions, :patients, column: :patient_id
    change_column_null :prescriptions, :patient_id, false

    change_column_null :prescriptions, :quantity, false

    add_reference :prescriptions, :formulation, foreign_key: {to_table: :formulation_types}, null: false

    remove_column :prescriptions, :frequency, :integer
    add_reference :prescriptions, :frequency, foreign_key: {to_table: :frequency_types}, null: false

    remove_column :prescriptions, :unit, :integer
    add_reference :prescriptions, :unit, foreign_key: {to_table: :unit_types}, null: false
  end
end
