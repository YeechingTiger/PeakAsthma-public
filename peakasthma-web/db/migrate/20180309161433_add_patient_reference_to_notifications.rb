class AddPatientReferenceToNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications_patients, id: false do |t|
      t.references :patient
      t.references :notification
    end
  end
end
