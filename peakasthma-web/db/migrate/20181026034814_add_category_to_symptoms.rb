class AddCategoryToSymptoms < ActiveRecord::Migration[5.2]
  def change
    add_column :symptoms, :category, :string
    add_column :symptoms, :emergency, :boolean
  end
end
