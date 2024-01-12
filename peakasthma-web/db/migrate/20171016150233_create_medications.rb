class CreateMedications < ActiveRecord::Migration[5.1]
  def change
    create_table :medications do |t|
      t.string :name, null: false
      t.integer :medication_type, null: false
      t.timestamps
    end

    add_index :medications, :name, unique: true

    create_table :medications_symptoms, id: false do |t|
      t.references :medication
      t.references :symptom
    end
  end
end
