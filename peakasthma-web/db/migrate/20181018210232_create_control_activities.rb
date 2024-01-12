class CreateControlActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :control_activities do |t|
      t.references :control_patient, foreign_key: true, null: false
      t.references :subject, polymorphic: true, null: false

      t.timestamps
    end
  end
end
