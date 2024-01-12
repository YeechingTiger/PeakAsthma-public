class AddMedTypeToMedications < ActiveRecord::Migration[5.2]
  def change
    create_table :medication_types do |t|
      t.string :kind, null: false
    end

    add_reference :medications, :type, foreign_key: {to_table: :medication_types}, null: false
  end
end
