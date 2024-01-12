class ChangeConfirmDefaultInPrescriptionTable < ActiveRecord::Migration[5.2]
  def change
    change_column_default :prescriptions, :confirm_status, nil
    change_column_default :prescriptions, :confirm_at, nil
  end
end
