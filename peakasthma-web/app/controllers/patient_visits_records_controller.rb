class PatientVisitsRecordsController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_patient_visits_record, only: [:edit, :update, :destroy, :show]

    def index
        @three_month_patient_visits_records = PatientVisitsRecord.where("three_month_scheduled_visit_date - timezone('utc', CURRENT_TIMESTAMP) < interval '14 days'")
        @three_month_control_patient_visits_records = ControlPatientVisitsRecord.where("three_month_scheduled_visit_date - timezone('utc', CURRENT_TIMESTAMP) < interval '14 days'")
        
        @three_month_patient_visits_records = @three_month_patient_visits_records + @three_month_control_patient_visits_records
        @three_month_patient_visits_records = @three_month_patient_visits_records.sort_by{|e| e[:three_month_scheduled_visit_date]}.reverse.paginate(page: params[:three_month_patient_visits_record_page], per_page: 5)



        @twelve_month_patient_visits_records = PatientVisitsRecord.where("twelve_month_scheduled_visit_date - timezone('utc', CURRENT_TIMESTAMP) < interval '90 days'")
        @twelve_month_control_patient_visits_records = ControlPatientVisitsRecord.where("twelve_month_scheduled_visit_date - timezone('utc', CURRENT_TIMESTAMP) < interval '90 days'")
        
        @twelve_month_patient_visits_records = @twelve_month_patient_visits_records + @twelve_month_control_patient_visits_records
        @twelve_month_patient_visits_records = @twelve_month_patient_visits_records.sort_by{|e| e[:twelve_month_scheduled_visit_date]}.reverse.paginate(page: params[:twelve_month_patient_visits_record_page], per_page: 5)

    end

    # def create
    #     @exacerbation = Exacerbation.create(exacerbation_params)
    #     respond_with @exacerbation, location: exacerbations_path
    # end

    def update
        @patient_visits_record.update(patient_visits_record_params)
        redirect_to patient_visits_records_url
    end

    # def destroy
    #     @exacerbation.destroy
    #     respond_with @exacerbation, location: exacerbations_path
    # end

    def edit
    end

    def show
    end

    # def new
    #     @exacerbation = Exacerbation.new
    # end

    private

    def find_patient_visits_record
        @patient_visits_record = PatientVisitsRecord.find(params[:id])
        @month = params[:month]
    end

    def patient_visits_record_params
        params.require(:patient_visits_record).permit(:three_month_payment_status, :three_month_comment, :three_month_visit_note, :twelve_month_payment_status, :twelve_month_comment, :twelve_month_visit_note)
    end
        
end
