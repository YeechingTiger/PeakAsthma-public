class ReadControlNotificationRecord < ApplicationRecord
  belongs_to :control_patient
  belongs_to :control_notification
end
