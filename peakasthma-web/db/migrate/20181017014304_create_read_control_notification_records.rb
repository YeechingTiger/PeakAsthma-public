class CreateReadControlNotificationRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :read_control_notification_records do |t|
      t.references :control_patient, foreign_key: true, null: false
      t.references :control_notification, foreign_key: true, null: false, index: false

      t.timestamps
    end
  end
end
