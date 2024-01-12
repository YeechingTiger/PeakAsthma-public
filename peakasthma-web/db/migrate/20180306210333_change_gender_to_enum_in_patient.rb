class ChangeGenderToEnumInPatient < ActiveRecord::Migration[5.1]
  def change
    remove_column :patients, :gender
    add_column :patients, :gender, :integer, default: 0, null: false
  end
end
