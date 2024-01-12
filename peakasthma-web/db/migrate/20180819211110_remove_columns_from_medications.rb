class RemoveColumnsFromMedications < ActiveRecord::Migration[5.2]
  def change
    remove_column :medications, :route, :integer
    remove_column :medications, :formulation, :integer
  end
end
