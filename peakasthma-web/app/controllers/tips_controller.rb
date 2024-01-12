class TipsController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_tip, only: [:edit, :update, :destroy, :show]

    def index
        @tips = Tip.all.order([:schedule]).paginate(page: params[:page])
    end

    def create
        @tip = Tip.create(tip_params)
        respond_with @tip, location: tips_path
    end

    def update
        @tip.update(tip_params)
        respond_with @tip, location: tips_path
    end

    def destroy
        @tip.destroy
        respond_with @tip, location: tips_path
    end

    def edit
    end

    def show
    end

    def new
        @tip = Tip.new
    end

    def send_tip
        @tip = Tip.where(id: params[:id])
        puts @tip
        @notification = Notification.create(
            patients: Patient.all,
            message: @tip[0]['tip'],
            send_at: DateTime.current)
        MassPatientNotificationJob.set(wait_until: @notification.send_at).perform_later(@notification)
        # render :json => Patient.all
        redirect_to tips_path
    end

    private
        def find_tip
            @tip = Tip.find(params[:id])
        end

        def tip_params
            params.require(:tip).permit(:tip, :schedule)
        end
end
