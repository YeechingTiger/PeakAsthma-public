class CreateClincardBalanceRequestTable < ActiveRecord::Migration[5.2]
  def change
    create_table :clincard_balance_requests do |t|
      t.references :patient, foreign_key: true
      t.string :comment
      t.timestamps
    end
  end
end
