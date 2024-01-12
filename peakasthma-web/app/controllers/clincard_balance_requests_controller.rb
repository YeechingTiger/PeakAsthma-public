class ClincardBalanceRequestsController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_clincard_balance_request, only: [:edit, :update, :destroy, :show]

    def index
        @clincard_balance_requests = ClincardBalanceRequest.all.order(created_at: :desc).paginate(page: params[:clincard_balance_request_page], per_page: 10)
    end

    def update
        @clincard_balance_request.update(clincard_balance_request_params)
        redirect_to clincard_balance_requests_url
    end

    def edit
    end

    def show
    end

    private

    def find_clincard_balance_request
        @clincard_balance_request = ClincardBalanceRequest.find(params[:id])
    end

    def clincard_balance_request_params
        params.require(:clincard_balance_request).permit(:comment)
    end
        
end
