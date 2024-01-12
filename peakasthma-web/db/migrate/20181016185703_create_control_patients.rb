class CreateControlPatients < ActiveRecord::Migration[5.2]
  def change
    create_table :control_patients do |t|
      t.date        :birthday
      t.integer     :gender, null: false, default: 0
      t.integer     :height
      t.float       :weight
      t.references  :user, foreign_key: true, null: false
      t.string      :phone
      t.string      :physician
      t.integer     :race
      t.string      :device_token
      t.boolean     :daily_reminders, default: false
      t.datetime    :daily_reminder_time
      t.timestamps
    end
  end
end
