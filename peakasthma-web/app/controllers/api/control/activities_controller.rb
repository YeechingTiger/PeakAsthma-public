module API::Control
  class ActivitiesController < API::Control::BaseController
    authenticated!

    def index
      @control_activities = current_user.control_patient.control_activities.order(created_at: :desc)
      respond_with @control_activities
    end
  end
end
