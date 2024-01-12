class AddGroupIdToPatientRewardRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_reward_records, :group_id, :string
  end
end
