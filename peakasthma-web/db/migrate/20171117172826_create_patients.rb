class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.date        :birthday
      t.string      :gender
      t.integer     :height
      t.float       :weight
      t.references  :user
      t.timestamps
    end

    remove_column :users, :birthday, :date
    remove_column :users, :gender, :string
    remove_reference :users, :physician

    remove_reference :prescriptions, :user, index: true
    add_reference :prescriptions, :patient

    remove_reference :peak_flows, :user, index: true
    add_reference :peak_flows, :patient

    remove_reference :symptom_reports, :user, index: true
    add_reference :symptom_reports, :patient

    remove_reference :guardians, :user, index: true
    add_reference :guardians, :patient
  end
end
