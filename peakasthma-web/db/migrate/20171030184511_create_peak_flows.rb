class CreatePeakFlows < ActiveRecord::Migration[5.1]
  def change
    create_table :peak_flows do |t|
      t.integer :score
      t.references :user
      t.timestamps
    end
  end
end
