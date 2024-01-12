class MedicationReminderNotificationJob < PatientNotificationJob

  def perform
    current_time = Time.current.utc.to_s(:time)
    time_of_last_check = (Time.current.utc - 2.minutes).to_s(:time)
    # filter out these patients whose green level medication's frequency is "as needed"
    # m_patients_to_notify = Patient.where("medication_reminders = true AND medication_reminder_time::time > ? AND medication_reminder_time::time <= ?", time_of_last_check, current_time).joins(:prescription).where("frequency_id != 1").joins(:prescription_level).where("level_id = 1")

    sql_top = 'SELECT "patients"."id"  FROM "prescriptions" INNER JOIN "prescription_levels" ON "prescription_levels"."prescription_id" = "prescriptions"."id" INNER JOIN "patients" ON "patients"."id" = "prescriptions"."patient_id" WHERE (frequency_id != 1) AND (level_id = 1) AND (medication_reminders = true) AND (valid_status = true)'
    
    sql_end = " AND (medication_reminder_time::time > '#{time_of_last_check}') AND (medication_reminder_time::time <= '#{current_time}')"

    sql = sql_top + sql_end
    puts sql
    m_patients_to_notify_id_list = ActiveRecord::Base.connection.exec_query(sql).to_a.map{ |x| x["id"] }
    puts m_patients_to_notify_id_list
    m_patients_to_notify = Patient.where("id IN (?)", m_patients_to_notify_id_list)
    puts Patient.where("id IN (?)", m_patients_to_notify_id_list).to_sql

    r_patients_to_notify = Patient.where("medication_reminders = true AND report_reminder_time::time > ? AND report_reminder_time::time <= ?", time_of_last_check, current_time) 
    # patients_to_notify = Patient.all
    if m_patients_to_notify.count > 0
      for patient in m_patients_to_notify
        m_notification = create_medication_reminder_notification(patient)
        super(m_notification, patient)
      end
    end

    if r_patients_to_notify.count > 0
      for patient in r_patients_to_notify
        r_notification=  create_report_feeling_reminder_notification(patient)
        super(r_notification, patient)
      end
    end
  end

  private
    def create_medication_reminder_notification(patient)
      @message = "Don’t forget to take your controller medications."
      Notification.create(
        alert: 3,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end

    def create_report_feeling_reminder_notification(patient)
      @message = "Don’t forget to record your peak flow or symptoms."

      Notification.create(
        alert: 4,
        patients: [ patient ],
        message: @message,
        send_at: DateTime.current)
    end
end
