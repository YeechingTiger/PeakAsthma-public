module ActivityFeed
  extend ActiveSupport::Concern

  def record_activity
    ActivityHistoryJob.perform_later(self)
  end

  included do
    after_create :record_activity
  end
end