class AddScheduleToTips < ActiveRecord::Migration[5.2]
  def change
    add_column :tips, :schedule, :integer
  end
end