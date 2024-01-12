class CreateIncentiveRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :incentive_records do |t|
      t.references :patient, foreign_key: true
      t.integer :day
      t.integer :week
      t.integer :month
      t.boolean :get_incentive, default: false
      t.timestamps
    end
  end
end
