class Activity < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :patient
end
