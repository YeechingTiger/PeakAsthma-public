class ReadNotificationRecord < ApplicationRecord
  belongs_to :patient
  belongs_to :notification
end
