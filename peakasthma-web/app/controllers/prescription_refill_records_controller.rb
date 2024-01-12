class PrescriptionRefillRecordsController < ApplicationController   
    authenticated!
    
    before_action :redirect_non_admin
    before_action :find_patient, only: [:create,:new, :edit, :update, :destroy]
    before_action :find_prescription, only: [:create,:new, :edit, :update, :destroy]
    before_action :find_prescription_refill_record, only: [:edit, :update, :destroy]
    
    def new
        @prescription_refill_record = PrescriptionRefillRecord.new
    end

    def create
        @prescription_refill_record = PrescriptionRefillRecord.create(prescription_refill_record_params)
        respond_with @prescription_refill_record, location: patient_path(@patient)
    end

    def update
        @prescription_refill_record.update(prescription_refill_record_params)
        respond_with @prescription_refill_record, location: patient_path(@patient)
    end
    
    def destroy
        @prescription_refill_record.destroy
        respond_with @prescription_refill_record, location: patient_path(@patient)
    end
    
    def edit
    end
    
    private
        def find_prescription_refill_record
            @prescription_refill_record = PrescriptionRefillRecord.find(params[:id])
        end
    
        def prescription_refill_record_params
            params.require(:prescription_refill_record).permit(:refill_date, :patient_id, :prescription_id)
        end
    
        def find_patient
            @patient = Patient.find(params[:patient_id])
        end
      
        def find_prescription
            @prescription = Prescription.find(params[:prescription_id])
        end
end
