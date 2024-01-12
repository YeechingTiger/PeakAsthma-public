class AddReferenceTokenToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :device_token, :string
  end
end
