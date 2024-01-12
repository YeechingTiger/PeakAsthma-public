class MassControlPatientNotificationJob < ControlNotificationJob

  def perform(notification)
    return unless notification && !notification.sent

    post_body = {
      to: '/topics/all',
      notification: {
        title: I18n.t('navigation.labels.control_app_title'),
        body: notification.message
      }
    }

    req = firebase_req(post_body)
    res = firebase_http.request(req)
    notification.update(sent: true) if res.code == '200'
    notification.control_patients = ControlPatient.all
  end

end
