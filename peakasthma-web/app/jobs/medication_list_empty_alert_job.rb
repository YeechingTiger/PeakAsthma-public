class MedicationListEmptyAlertJob < ApplicationJob

  def perform
    # if patient has no valid prescription and registered over 24h. If already has an alert but over 24h, create a new one. If no alert, create a new one.
    patients = Patient.all
    puts patients.size
    now = Time.now
    for p in patients
      if p.user.disabled == false
        @patient_prescription = Prescription.where("patient_id=?", p.id).where("valid_status=TRUE").all
        if @patient_prescription.size == 0
          puts p.id
          time_dif = (now - p.created_at) / 1.hours
          puts time_dif
          if time_dif.to_i >= 24
            latest_alert = AlertTable.where("patient_id=?", p.id).order(created_at: :desc).first
            if latest_alert.nil?
              AlertTable.create({:patient_id => p.id, :alert => "No medication entered for the patient. Please check the profile."})
            elsif ((now - latest_alert.created_at) / 1.hours >= 24)
              AlertTable.create({:patient_id => p.id, :alert => "No medication entered for the patient. Please check the profile."})
            end
          end
        end
      end
    end
  end 
end
