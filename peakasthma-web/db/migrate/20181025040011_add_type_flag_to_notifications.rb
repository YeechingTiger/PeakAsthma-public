class AddTypeFlagToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :tip_flag, :boolean, default: false
  end
end
