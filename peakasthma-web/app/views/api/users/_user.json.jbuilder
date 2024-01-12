json.authentication_token user.authentication_token
json.first_name user.first_name
json.last_name user.last_name
json.username user.username
json.id user.id
json.enroll_time user.created_at
json.email user.email
json.first_time_login user.first_mobile_login?
json.accept_policy user.accept_policy?
json.account_disabled user.disabled?

if user.patient?
  json.patient_type 'patient'
  json.birthday user.patient.birthday
  json.gender user.patient.gender
  json.physician user.patient.physician

  json.medication_reminders user.patient.medication_reminders
  json.medication_reminder_time user.patient.medication_reminder_time
  json.report_reminder_time user.patient.report_reminder_time

  json.remind_later_time user.patient.remind_later_time

  json.peak_flow_low user.patient.yellow_zone_minimum
  json.peak_flow_high user.patient.yellow_zone_maximum

  json.guardians user.patient.guardians do |guardian|
    json.first_name guardian.user.first_name
    json.last_name guardian.user.last_name
    json.relationship_to_patient guardian.relationship_to_patient
  end
end

if user.control_patient?
  json.patient_type 'control_patient'
  json.birthday user.control_patient.birthday
  json.gender user.control_patient.gender
  json.physician user.control_patient.physician

  json.daily_reminders user.control_patient.daily_reminders
  json.daily_reminder_time user.control_patient.daily_reminder_time
end
