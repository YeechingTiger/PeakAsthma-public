class ChangePatientRedcapId < ActiveRecord::Migration[5.2]
  def change
    change_column_null :patients, :redcap_id, false
  end
end
