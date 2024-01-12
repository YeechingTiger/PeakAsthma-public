class AddRemindLaterToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :remind_later_time, :integer
  end
end
