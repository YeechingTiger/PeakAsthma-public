class AddValidToPrescriptionTable < ActiveRecord::Migration[5.2]
  def change
    add_column :prescriptions, :valid_status, :boolean, default: true
    add_column :prescriptions, :invalid_reason, :string
    add_column :prescriptions, :invalid_at, :datetime
    add_column :prescriptions, :confirm_status, :boolean
    add_column :prescriptions, :confirm_at, :datetime
  end
end
