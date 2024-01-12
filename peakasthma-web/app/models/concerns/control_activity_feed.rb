module ControlActivityFeed
  extend ActiveSupport::Concern

  def record_activity
    ControlActivityHistoryJob.perform_later(self)
  end

  included do
    after_create :record_activity
  end
end