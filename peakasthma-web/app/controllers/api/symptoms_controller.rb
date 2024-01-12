module API
  class SymptomsController < API::BaseController
    authenticated!

    def index
      if params[:level]
        @symptoms = Symptom.where(level: params[:level])
      else
        @symptoms = Symptom.all
      end
      
      respond_with @symptoms
    end
  end
end
