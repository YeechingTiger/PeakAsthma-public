json.authentication_token user.authentication_token
json.first_name user.first_name
json.last_name user.last_name
json.username user.username
json.id user.id
json.email user.email
json.first_time_login user.first_mobile_login?
json.accept_policy user.accept_policy?
json.account_disabled user.disabled?

json.patient_type 'control_patient'
json.birthday user.control_patient.birthday
json.gender user.control_patient.gender
json.physician user.control_patient.physician

json.daily_reminders user.control_patient.daily_reminders
json.daily_reminder_time user.control_patient.daily_reminder_time
