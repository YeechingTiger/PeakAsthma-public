class LikeVideoJob < ApplicationJob
  queue_as :default

  def perform(patient, video)
    if patient.videos.include?(video)
      patient.videos.delete(video)
    else
      patient.videos.push(video)
    end
  end
end
