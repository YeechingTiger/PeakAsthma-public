json.notification do
  json.partial! 'api/notifications/notification', notification: @read_notification_record.notification
end
json.created @read_notification_record.created_at