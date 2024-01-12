class ControlPatientRewardRecordsController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_reward_record, only: [:edit, :update, :destroy, :show]

    def index
        @reward_records = ControlPatientRewardRecord.all.order(logging_over_day: :desc).paginate(page: params[:reward_record_page], per_page: 10)
    end

    # def create
    #     @exacerbation = Exacerbation.create(exacerbation_params)
    #     respond_with @exacerbation, location: exacerbations_path
    # end

    def update
        puts reward_record_params
            # check survey status 
        data = RedcapAPI.get_patient_monthly_survey(@reward_record.control_patient.redcap_id, @reward_record.month)
        if data == nil
            # Survey not completed, do nothing, keep the original record
            # puts "updating-----------------------------"
            @reward_record.update(survey_complete:false, survey_complete_day:nil)
        else
            # Survey completed, update the record
            # puts "updating-----------------------------"
            # puts data[0]
            survey_finish_date = (data[0]["m_date"] != nil) ? DateTime.parse(data[0]["m_date"]) : DateTime.parse(data[0]["m69_date"])

            @reward_record.update(survey_complete:true, survey_complete_day:survey_finish_date)
        end
        @reward_record.update(reward_record_params)
        redirect_to patient_reward_records_url
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

    def find_reward_record
        @reward_record = ControlPatientRewardRecord.find(params[:id])
    end

    def reward_record_params
        params.require(:control_patient_reward_record).permit(:get_paid, :comment)
    end
        
end
