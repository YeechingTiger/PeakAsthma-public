class ChangeTwilioPcExacerbationReference < ActiveRecord::Migration[5.2]
  def change
    remove_reference :twilio_phone_calls, :exacerbations
    add_reference :twilio_phone_calls, :exacerbation
  end
end
