module API
  class ActivitiesController < API::BaseController
    authenticated!

    def index
      @activities = current_user.patient.activities.order(created_at: :desc)
      respond_with @activities
    end
  end
end
