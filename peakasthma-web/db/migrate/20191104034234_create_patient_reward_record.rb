class CreatePatientRewardRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_reward_records do |t|
      t.references :patient, foreign_key: true
      t.datetime :logging_over_day
      t.float :payment_amount
      t.integer :month
      t.boolean :get_paid, default: false
      t.boolean :survey_complete
      t.datetime :survey_complete_day
      t.string :comment
      t.timestamps
    end
  end
end
