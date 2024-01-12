class PatientExacerbationMailer < ApplicationMailer
  track message: true
  track open: true, click: false
  track extra: -> { {exacerbation_id: @exacerbation_id} }
  default from: 'notification_noreply@PeakAsthma.com'

  def yellow_patient_exacerbation_email(guardian, exacerbation_id)
    @exacerbation_id =  exacerbation_id
    guardian_emails = [guardian].collect(&:user).collect(&:email)
    send_to_emails = guardian_emails.join(",")
    mail(to: send_to_emails, subject: I18n.t('patient_exacerbation_email.yellow.subject'))
  end


  def red_patient_exacerbation_email(guardian, exacerbation_id)
    @exacerbation_id =  exacerbation_id
    guardian_emails = [guardian].collect(&:user).collect(&:email)
    send_to_emails = guardian_emails.join(",")
    mail(to: send_to_emails, subject: I18n.t('patient_exacerbation_email.red.subject'))
  end

  def yellow_patient_exacerbation_email_admin(exacerbation_id)
    @exacerbation_id =  exacerbation_id
    admin_emails = User.admins.collect(&:email)
    send_to_emails = admin_emails.join(",")
    mail(to: send_to_emails, subject: I18n.t('patient_exacerbation_email.yellow.subject'))
  end

  def red_patient_exacerbation_email_admin(exacerbation_id)
    @exacerbation_id =  exacerbation_id
    admin_emails = User.admins.collect(&:email)
    puts admin_emails
    send_to_emails = admin_emails.join(",")
    puts send_to_emails
    mail(to: send_to_emails, subject: I18n.t('patient_exacerbation_email.red.subject'))
  end

  def test_email()
    admin_emails = User.admins.collect(&:email)
    send_to_emails = (admin_emails).join(',')
    mail(to: send_to_emails, subject: I18n.t('patient_exacerbation_email.red.subject'))
  end
end
