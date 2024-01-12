module API
  class ClincardBalanceRequestsController < API::BaseController
    authenticated!

    def send_request
      ClincardBalanceRequest.create({:user_id => current_user.id})
    end

  end
end
