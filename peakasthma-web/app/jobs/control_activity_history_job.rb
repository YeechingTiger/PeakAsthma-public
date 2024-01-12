class ControlActivityHistoryJob < ApplicationJob
  queue_as :default

  def perform(subject)
    ControlActivity.create(subject: subject, control_patient: subject.control_patient, created_at: subject.created_at)
  end
end
