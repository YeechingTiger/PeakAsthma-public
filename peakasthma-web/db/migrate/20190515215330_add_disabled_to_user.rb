class AddDisabledToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :disabled, :boolean, null: false, default: false
  end
end
