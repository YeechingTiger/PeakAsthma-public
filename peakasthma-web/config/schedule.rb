# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, {:error => '~/z.error.log', :standard => '~/z.standard.log'}
set :time_zone, 'Central Time (US & Canada)'

every 2.minutes do
  runner 'MedicationReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'PrescriptionReminderNotificationJob.perform_later'
end

every 2.minutes do
  runner 'DailyReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'SendTipsJob.perform_later'
end

every 24.hours do
  runner 'ClearMedReminderJob.perform_later'
end

every 24.hours do
  runner 'LoginReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'ControlLoginReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'BirthdayReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'ControlBirthdayReminderNotificationJob.perform_later'
end

every 24.hours do
  runner 'PatientRewardRecordJob.perform_later'
end

every 24.hours do
  runner 'ControlPatientRewardRecordJob.perform_later'
end

every 24.hours do
  runner 'PatientVisitJob.perform_later'
end

every 24.hours do
  runner 'ControlPatientVisitJob.perform_later'
end

every 1.hours do
  runner 'MedicationListEmptyAlertJob.perform_later'
end

every 1.days, at: '7:30 am' do
  runner 'SurveyTwilioReminderNotificationJob.perform_later'
end

every 1.days, at: '7:30 am' do
  runner 'ControlSurveyTwilioReminderNotificationJob.perform_later'
end

every 1.days, at: '7:30 am' do
  runner 'SurveyNotificationJob.perform_later'
end

every 1.days, at: '17:00 pm' do
  runner 'SurveyNotificationJob.perform_later'
end

every 1.days, at: '7:30 am' do
  runner 'ControlSurveyNotificationJob.perform_later'
end

every 1.days, at: '17:00 pm' do
  runner 'ControlSurveyNotificationJob.perform_later'
end

every 2.days, at: '7:30 am' do
  runner 'SurveyReminderNotificationJob.perform_later'
end

every 2.days, at: '17:00 pm' do
  runner 'SurveyReminderNotificationJob.perform_later'
end

every 2.days, at: '7:30 am' do
  runner 'ControlSurveyReminderNotificationJob.perform_later'
end

every 2.days, at: '17:00 pm' do
  runner 'ControlSurveyReminderNotificationJob.perform_later'
end

