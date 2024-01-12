module API::Control
  class UsersController < API::Control::BaseController
    authenticated!

    def current
      puts request.headers["X-PeakAsthma-Device-Token"]
      puts '-----------------------------------------------------'
    
      puts warden.session['unique_session_id']
      puts current_user.unique_session_id
      puts '-----------------------------------------------------'

      respond_with current_user
    end

    def accept_policy
      current_user.update(accept_policy: true)
      current_user.update(used_mobile_app: true)
      respond_with current_user
    end
  end
end
