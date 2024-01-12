class AddRedcapIdToControlPatient < ActiveRecord::Migration[5.2]
  def change
    add_column :control_patients, :redcap_id, :string
    add_index :control_patients, :redcap_id, unique: true
  end
end
