class AddSymptomsToPeakFlow < ActiveRecord::Migration[5.1]
  def change
    drop_table :symptom_reports
    drop_table :symptom_reports_symptoms

    create_table :peak_flows_symptoms, id: false do |t|
      t.references :symptom
      t.references :peak_flow
    end
  end
end
