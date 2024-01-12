class AddFirstTimeMobileLoginToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :used_mobile_app, :boolean, default: false
  end
end
