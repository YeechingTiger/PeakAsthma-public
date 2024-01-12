class ChangePatientVisitsRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_visits_records, :three_month_visit_note, :string
    add_column :patient_visits_records, :twelve_month_visit_note, :string
    remove_column :patient_visits_records, :three_month_visit_date
    remove_column :patient_visits_records, :twelve_month_visit_date
  end
end
