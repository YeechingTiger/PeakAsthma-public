class AddTwilioPhoneCallDatabase < ActiveRecord::Migration[5.2]
  def change
    create_table :twilio_phone_call do |t|
      t.string :twilio_sid, null: false
      t.references :exacerbations
    end
  end
end
