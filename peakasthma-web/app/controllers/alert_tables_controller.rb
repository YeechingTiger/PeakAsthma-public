class AlertTablesController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_alert_table, only: [:edit, :update, :destroy, :show]

    def index
        @alert_tables = AlertTable.all.order(created_at: :desc).paginate(page: params[:alert_table_page], per_page: 10)
    end

    def update
        @alert_table.update(alert_table_params)
        redirect_to root_path
    end

    def edit
    end

    def show
    end

    private

    def find_alert_table
        @alert_table = AlertTable.find(params[:id])
    end

    def alert_table_params
        params.require(:alert_table).permit(:comment)
    end
        
end
