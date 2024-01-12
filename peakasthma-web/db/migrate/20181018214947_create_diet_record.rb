class CreateDietRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :diet_records do |t|
      t.references :control_patient, foreign_key: true, null: false
      t.integer :fruit, null: false, default: 0
      t.integer :vegetable, null: false, default: 0

      t.timestamps
    end
  end
end
