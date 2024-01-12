class CreateSymptomReports < ActiveRecord::Migration[5.1]
  def change
    create_table :symptom_reports do |t|
      t.references :user
      t.timestamps
    end

    create_table :symptom_reports_symptoms, id: false do |t|
      t.references :symptom_report
      t.references :symptom
    end
  end
end
