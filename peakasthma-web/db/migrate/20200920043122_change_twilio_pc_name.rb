class ChangeTwilioPcName < ActiveRecord::Migration[5.2]
  def change
    rename_table :twilio_phone_call, :twilio_phone_calls
  end
end
