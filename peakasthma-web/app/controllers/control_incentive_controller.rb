class ControlIncentiveController < ApplicationController
    authenticated!
    before_action :redirect_non_admin

    def index
        @incentives = ControlIncentiveRecord.where(control_patient_id: params[:control_patient_id])
    end
end
