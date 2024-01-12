class ClearMedReminderJob < ApplicationJob
  queue_as :default

  def perform()
    queue = Sidekiq::ScheduledSet.new
    puts queue.inspect
    jobs = queue.map do |job|
      puts job.queue
      if job.queue == 'med_reminder'
        job.reschedule(1.second.from_now)
      end
    end.compact
  end
end
