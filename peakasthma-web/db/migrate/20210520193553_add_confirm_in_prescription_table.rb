class AddConfirmInPrescriptionTable < ActiveRecord::Migration[5.2]
  def change
    add_column :prescriptions, :confirm_status, :boolean, default: true
    add_column :prescriptions, :confirm_at, :datetime, default: '2021-05-20 01:51:03.747205'
  end
end
