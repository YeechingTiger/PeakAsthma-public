class ChangeConfirmInPrescriptionTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :prescriptions, :confirm_status
    remove_column :prescriptions, :confirm_at
  end
end
