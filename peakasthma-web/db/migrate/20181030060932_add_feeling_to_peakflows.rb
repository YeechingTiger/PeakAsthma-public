class AddFeelingToPeakflows < ActiveRecord::Migration[5.2]
  def change
    add_column :peak_flows, :feeling, :string
  end
end
