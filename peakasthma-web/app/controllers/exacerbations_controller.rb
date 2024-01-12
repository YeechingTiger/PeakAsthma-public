class ExacerbationsController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_exacerbation, only: [:edit, :update, :destroy, :show]

    def index
        # @exacerbations = Exacerbation.all.order([:exacerbation]).paginate(page: params[:page])
        @exacerbations = Exacerbation.joins('LEFT JOIN ahoy_messages ON exacerbations.id = ahoy_messages.exacerbation_id AND ahoy_messages.user_id != 1 and ahoy_messages.user_id IS NOT NULL').order([:exacerbation]).paginate(page: params[:page])
        puts @exacerbations
        twilio_phone_call_status
    end

    def create
        @exacerbation = Exacerbation.create(exacerbation_params)
        respond_with @exacerbation, location: exacerbations_path
    end

    def update
        @exacerbation.update(exacerbation_params)
        redirect_to root_path
    end

    def destroy
        @exacerbation.destroy
        respond_with @exacerbation, location: exacerbations_path
    end

    def edit
    end

    def show
        @alert_emails = Ahoy::Message.where("exacerbation_id = ?", @exacerbation.id)
    end

    def new
        @exacerbation = Exacerbation.new
    end

    private
        def find_exacerbation
            @exacerbation = Exacerbation.find(params[:id])
        end

        def exacerbation_params
            params.require(:exacerbation).permit(:exacerbation, :comment, :status)
        end

        def twilio_phone_call_status
            account_sid = Rails.application.secrets.twilio_sid
            auth_token = Rails.application.secrets.twilio_token
            @client = Twilio::REST::Client.new account_sid, auth_token
            calls = @client.calls.list()
            @exacerbation_phone_call_status_dict = Hash.new
            @exacerbation_phone_calls = TwilioPhoneCall.all
            
            for exacerbation_phone_call in @exacerbation_phone_calls
              call = calls.select { |call| call.sid == exacerbation_phone_call.twilio_sid }
              @exacerbation_phone_call_status_dict[exacerbation_phone_call.exacerbation_id] = call[0].status
            end
          end
end
