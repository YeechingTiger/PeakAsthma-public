module API::Control
  class ClincardBalanceRequestsController < API::Control::BaseController
    authenticated!

    def send_request
      ClincardBalanceRequest.create({:user_id => current_user.id})
    end

  end
end
