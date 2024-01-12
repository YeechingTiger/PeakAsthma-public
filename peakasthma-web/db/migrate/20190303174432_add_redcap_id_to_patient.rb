class AddRedcapIdToPatient < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :redcap_id, :string
    add_index :patients, :redcap_id, unique: true
  end
end
