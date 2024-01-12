class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.references :patient
      t.references :subject, polymorphic: true

      t.timestamps
    end
  end
end
