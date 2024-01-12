class AddPeakFlowRangeToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :yellow_zone_minimum, :integer, default: 170
    add_column :patients, :yellow_zone_maximum, :integer, default: 220
  end
end
