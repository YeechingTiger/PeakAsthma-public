class CreatePrescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :prescriptions do |t|
      t.float :amount
      t.string :unit
      t.integer :frequency, null: false
      t.integer :period, null: false
      t.references :user
      t.references :medication
      t.references :prescriber, references: :users
      t.timestamps
    end
  end
end
