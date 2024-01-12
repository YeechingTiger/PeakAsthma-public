# Preview all emails at http://localhost:3000/rails/mailers/admin_exacerbation_mailer
class PatientExacerbationMailerPreview < ActionMailer::Preview
  def yellow_patient_exacerbation_mail
    PatientExacerbationMailer.yellow_patient_exacerbation_email(Patient.first)
  end

  def red_patient_exacerbation_mail
    PatientExacerbationMailer.red_patient_exacerbation_email(Patient.first)
  end
end
