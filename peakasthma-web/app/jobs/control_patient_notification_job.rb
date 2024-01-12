class ControlPatientNotificationJob < ControlNotificationJob

  def perform(notification, patient)
    return unless notification && !notification.sent && !patient.user.disabled
    
    post_body = {
      to: patient.device_token,
      notification: {
        title: I18n.t('navigation.labels.control_app_title'),
        body: notification.message
      }
    }
    res = firebase_http.request(firebase_req post_body)
    notification.update(sent: true) if res.code == '200'
    notification.control_patients = [ patient ]
    res
  end
end
