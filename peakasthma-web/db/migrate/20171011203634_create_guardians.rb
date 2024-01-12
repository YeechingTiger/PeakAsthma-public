class CreateGuardians < ActiveRecord::Migration[5.1]
  def change
    create_table :guardians do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :relationship_to_patient, null: false

      t.timestamps null: false
      t.references :user
    end

    add_index :guardians, :email, unique: true

    add_column :users, :physician_id, :integer
  end
end
