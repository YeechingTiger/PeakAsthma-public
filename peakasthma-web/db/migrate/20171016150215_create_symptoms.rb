class CreateSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :symptoms do |t|
      t.string :name, null: false
      t.integer :level, null: false
      t.timestamps
    end

    add_index :symptoms, :name, unique: true
  end
end
