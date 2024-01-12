class ChangePatientIdToControlPatientId < ActiveRecord::Migration[5.2]
  def change
    remove_reference :control_patient_visits_records, :patient
    add_reference :control_patient_visits_records, :control_patient, foreign_key: true
  end
end
