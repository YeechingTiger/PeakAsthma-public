class AddPrescriptionNotificationPrefsToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :medication_reminders, :boolean, default: false
    add_column :patients, :medication_reminder_time, :time
  end
end
