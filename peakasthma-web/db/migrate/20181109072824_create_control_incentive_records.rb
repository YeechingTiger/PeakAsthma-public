class CreateControlIncentiveRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :control_incentive_records do |t|
      t.references :control_patient, foreign_key: true
      t.integer :day
      t.integer :week
      t.integer :month
      t.boolean :get_incentive, default: false
      t.timestamps
    end
  end
end
