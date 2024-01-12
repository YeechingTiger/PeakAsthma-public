class AddAcceptPolicyToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :accept_policy, :boolean, null: false, default: false
  end
end
