class PrescriptionRefillRecord < ApplicationRecord
    belongs_to :prescription
    belongs_to :patient

    validates :refill_date, presence: true
end
