class AddTargetPatientToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :target_patient, :integer
  end
end
