class AddAssignedLevelForConfirmedChangedPrescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :confirmed_changed_prescriptions, :assigned_level, :string
  end
end
