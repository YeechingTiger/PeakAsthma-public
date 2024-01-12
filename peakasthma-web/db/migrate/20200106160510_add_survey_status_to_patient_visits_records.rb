class AddSurveyStatusToPatientVisitsRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_visits_records, :three_month_survey_status, :boolean, default: false
    add_column :patient_visits_records, :twelve_month_survey_status, :boolean, default: false
  end
end
