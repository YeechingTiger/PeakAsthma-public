class ChangeGuardians < ActiveRecord::Migration[5.2]
  def change
    remove_column :guardians, :email
    remove_column :guardians, :first_name
    remove_column :guardians, :last_name
    add_reference :guardians, :user
  end
end
