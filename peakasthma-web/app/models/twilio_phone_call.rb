class TwilioPhoneCall < ApplicationRecord
    belongs_to :exacerbation
    
    validates :exacerbation_id, presence: true
    validates :twilio_sid, presence: true
end
