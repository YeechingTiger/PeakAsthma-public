class CreateControlNotificationControlPatient < ActiveRecord::Migration[5.2]
  def change
    create_table :control_notifications_control_patients do |t|
      t.references :control_patient, foreign_key: true, null: false, index: false
      t.references :control_notification, foreign_key: true, null: false, index: false
    end

    add_index :control_notifications_control_patients, :control_notification_id, name: "index_control_notifications_control_patients"
    remove_column :control_notifications_control_patients, :id
  end
end
