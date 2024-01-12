class CreateReadNotificationRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :read_notification_records do |t|
      t.references :patient
      t.references :notification

      t.timestamps
    end
  end
end
