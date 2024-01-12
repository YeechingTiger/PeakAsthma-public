module API
  class VideosController < API::BaseController
    authenticated!
    before_action :find_video, only: [:likeVideo] 
    
    def avbVideo
      @videos = Video.all.order(week: :asc, day: :asc)
      @like_videos = current_user.patient.videos
      respond_with [@videos, @like_videos]
    end
    
    def likeVideo
      LikeVideoJob.perform_later(current_user.patient, @video)
    end

    private
      def find_video
        @video = Video.find(params[:video_id])
      end
  end
end
