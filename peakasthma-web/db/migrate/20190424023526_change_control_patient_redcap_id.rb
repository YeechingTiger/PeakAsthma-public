class ChangeControlPatientRedcapId < ActiveRecord::Migration[5.2]
  def change
    change_column_null :control_patients, :redcap_id, false
  end
end
