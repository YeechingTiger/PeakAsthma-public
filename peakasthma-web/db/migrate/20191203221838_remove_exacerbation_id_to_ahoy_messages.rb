class RemoveExacerbationIdToAhoyMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :ahoy_messages, :exacerbation_id, :integer
    add_column :ahoy_messages, :exacerbation_id, :integer
  end
end
