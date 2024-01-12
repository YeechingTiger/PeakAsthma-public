class AddContactFieldsToPatientGuardian < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :phone, :string
    add_column :patients, :physician, :string
    add_column :guardians, :phone, :string
  end
end