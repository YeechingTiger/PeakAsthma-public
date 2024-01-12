class CreateExacerbations < ActiveRecord::Migration[5.1]
  def change
    create_table :exacerbations do |t|
      t.bigint "patient_id"
      t.string :exacerbation
      t.string :comment
      t.integer :status
      t.timestamps
    end
  end
end
