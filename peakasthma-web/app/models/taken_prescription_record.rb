class TakenPrescriptionRecord < ApplicationRecord
  include ActivityFeed

  belongs_to :patient
  belongs_to :prescription
end
