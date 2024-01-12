class VideosController < ApplicationController
    authenticated!

    before_action :redirect_non_admin
    before_action :find_video, only: [:edit, :update, :destroy, :show]

    def index
        @videos = Video.all.order([:week, :day]).paginate(page: params[:page])
    end

    def create
        @video = Video.create(video_params)
        respond_with @video, location: videos_path
    end

    def update
        @video.update(video_params)
        respond_with @video, location: videos_path
    end

    def destroy
        @video.destroy
        respond_with @video, location: videos_path
    end

    def edit
    end

    def show
    end

    def new
        @video = Video.new
    end

    private
        def find_video
            @video = Video.find(params[:id])
        end

        def video_params
            params.require(:video).permit(:video_name, :url, :week, :day)
        end
end
