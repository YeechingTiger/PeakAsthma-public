class CreateTakenPrescriptionRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :taken_prescription_records do |t|
      t.references :patient
      t.references :prescription

      t.timestamps
    end
  end
end
