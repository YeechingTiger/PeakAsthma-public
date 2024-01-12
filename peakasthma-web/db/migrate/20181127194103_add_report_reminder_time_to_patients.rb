class AddReportReminderTimeToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :report_reminder_time, :datetime, null: true
  end
end
