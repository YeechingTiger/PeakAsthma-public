class AddTargetPatientToControlNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :control_notifications, :target_patient, :integer
  end
end
