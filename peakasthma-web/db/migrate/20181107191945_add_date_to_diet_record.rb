class AddDateToDietRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :diet_records, :record_date, :date, null: false
  end
end
