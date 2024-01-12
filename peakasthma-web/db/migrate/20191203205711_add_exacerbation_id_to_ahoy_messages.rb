class AddExacerbationIdToAhoyMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :ahoy_messages, :exacerbation_id, :integer
    add_foreign_key :ahoy_messages, :exacerbations
  end
end
