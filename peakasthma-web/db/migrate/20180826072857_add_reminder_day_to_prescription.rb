class AddReminderDayToPrescription < ActiveRecord::Migration[5.2]
  def change
    add_column :prescriptions, :reminder_day, :integer
  end
end
