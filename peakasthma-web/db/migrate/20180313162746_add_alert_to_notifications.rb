class AddAlertToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :alert, :boolean, default: false
  end
end
