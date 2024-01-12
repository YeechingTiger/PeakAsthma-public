class IncentiveController < ApplicationController
    authenticated!
    before_action :redirect_non_admin

    def index
        @incentives = IncentiveRecord.where(patient_id: params[:patient_id])
    end
end
