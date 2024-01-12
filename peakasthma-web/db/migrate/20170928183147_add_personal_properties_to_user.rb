class AddPersonalPropertiesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string

    add_index :users, :username, unique: true
  end
end
