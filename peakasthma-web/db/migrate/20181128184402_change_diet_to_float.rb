class ChangeDietToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :diet_records, :fruit, :float
    change_column :diet_records, :vegetable, :float
  end
end
