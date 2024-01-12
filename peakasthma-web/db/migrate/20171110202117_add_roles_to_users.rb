class AddRolesToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :role, :integer, default: User.roles[:patient], null: false

    User.find_each do |user|
      user.role = User.roles[:patient]
      user.save!
    end
  end

  def down
    remove_column :users, :role
  end
end
