class CreateControlNotification < ActiveRecord::Migration[5.2]
  def change
    create_table :control_notifications do |t|
      t.string :message, null: false
      t.datetime :send_at, null: false
      t.boolean :sent, default: false, null: false
      t.references :user, foreign_key: true
      t.integer :alert, default: 0, null: false
      t.timestamps
    end
  end
end
