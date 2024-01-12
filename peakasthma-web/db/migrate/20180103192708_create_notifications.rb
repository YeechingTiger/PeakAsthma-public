class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :message, null: false
      t.datetime :send_at, null: false
      t.boolean :sent, default: false

      t.references :user

      t.timestamps
    end
  end
end
