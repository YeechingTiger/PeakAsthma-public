class ActivityHistoryJob < ApplicationJob
  queue_as :default

  def perform(subject)
    Activity.create(subject: subject, patient: subject.patient, created_at: subject.created_at)
  end
end
