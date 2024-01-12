class AddZipRaceToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :race, :integer
    add_column :patients, :zip_code, :integer
  end
end
