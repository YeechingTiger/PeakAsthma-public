class CreatePrescriptionRefillRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :prescription_refill_records do |t|
      t.references :patient
      t.references :prescription
      t.date       :refill_date
      t.timestamps
    end
  end
end
