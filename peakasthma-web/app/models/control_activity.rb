class ControlActivity < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :control_patient
end
