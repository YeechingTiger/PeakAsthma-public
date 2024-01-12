class DietRecord < ApplicationRecord
  include ControlActivityFeed

  belongs_to :control_patient
end
