class CreateConfirmedChangedPrescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :confirmed_changed_prescriptions do |t|
      t.references :medication
      t.references :prescriber, references: :users
      t.references :patient
      t.integer :quantity
      t.references :formulation, foreign_key: {to_table: :formulation_types}, null: false
      t.references :frequency, foreign_key: {to_table: :frequency_types}, null: false
      t.references :unit, foreign_key: {to_table: :unit_types}, null: false
      t.integer :reminder_day
      t.timestamps
    end
  end
end