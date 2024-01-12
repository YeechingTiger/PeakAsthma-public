class CreateAlertTable < ActiveRecord::Migration[5.2]
  def change
    create_table :alert_tables do |t|
      t.references :patient, foreign_key: true
      t.string :alert
      t.string :comment
      t.timestamps
    end
  end
end
