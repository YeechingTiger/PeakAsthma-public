class AddNotificationTypeToGuardians < ActiveRecord::Migration[5.2]
  def change
    add_column :guardians, :notification_type, :integer, default: 0
  end
end