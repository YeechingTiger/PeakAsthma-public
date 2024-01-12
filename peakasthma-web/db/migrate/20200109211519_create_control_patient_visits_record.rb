class CreateControlPatientVisitsRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :control_patient_visits_records do |t|
      t.references :patient, foreign_key: true
      t.datetime :three_month_scheduled_visit_date
      t.boolean :three_month_survey_status
      t.boolean :three_month_payment_status, default: false
      t.string :three_month_visit_note
      t.string :three_month_comment
      t.datetime :twelve_month_scheduled_visit_date
      t.boolean :twelve_month_survey_status
      t.boolean :twelve_month_payment_status, default: false
      t.string :twelve_month_visit_note
      t.string :twelve_month_comment
      t.timestamps
    end
  end
end
