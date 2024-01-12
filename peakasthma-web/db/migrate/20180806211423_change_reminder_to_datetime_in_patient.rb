class ChangeReminderToDatetimeInPatient < ActiveRecord::Migration[5.1]
    def change
      remove_column :patients, :medication_reminder_time
      add_column :patients, :medication_reminder_time, :datetime, null: true
    end
  end
  