class CreatePrescriptionLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :level_types do |t|
      t.string :kind, null: false
    end

    create_table :prescription_levels do |t|
      t.references :prescription, foreign_key: true, null: false
      t.references :level, foreign_key: {to_table: :level_types}, null: false
    end
  end
end
