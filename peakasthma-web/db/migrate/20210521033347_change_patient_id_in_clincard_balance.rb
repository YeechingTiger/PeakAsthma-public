class ChangePatientIdInClincardBalance < ActiveRecord::Migration[5.2]
  def change
    rename_column :clincard_balance_requests, :patient_id, :user_id
  end
end
