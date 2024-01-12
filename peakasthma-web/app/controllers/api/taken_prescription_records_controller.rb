module API
  class TakenPrescriptionRecordsController < API::BaseController
    # authenticated!

    def create
      puts prescription_levels.inspect
      @taken_prescription_record = current_user.patient.taken_prescription_records.create(prescription: patient_prescription) 
      for prescription_level in prescription_levels
        if(prescription_level.level_id == 1 and prescription_levels.length == 1)
          respond_with @taken_prescription_record and return
        end
      end
      respond_with @taken_prescription_record
    end

    def reminder_later
      @minutes = params[:minutes].to_i
      @color = params[:color]
      @patient = current_user.patient
      puts DateTime.current
      MedicationCustomReminderNotificationJob.set(wait: @minutes.minutes).perform_later(@patient, @color)
      render :json => {}
    end

    private
      def patient_prescription
        current_user.patient.prescriptions.find(params[:id])
      end

      def prescription_levels
        PrescriptionLevel.where(prescription_id: params[:id])
      end
  end
end
