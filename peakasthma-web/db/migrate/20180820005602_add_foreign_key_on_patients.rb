class AddForeignKeyOnPatients < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :patients, :users, column: :user_id
  end
end
