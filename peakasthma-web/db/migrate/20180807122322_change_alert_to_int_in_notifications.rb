class ChangeAlertToIntInNotifications < ActiveRecord::Migration[5.1]
    def change
      remove_column :notifications, :alert
      add_column :notifications, :alert, :integer, default: 0, null: false
    end
  end
  