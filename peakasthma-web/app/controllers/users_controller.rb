class UsersController < ApplicationController
  authenticated!

  before_action :redirect_non_admin
  before_action :find_user, only: [:edit, :update, :destroy]

  def index
    @users = User.where(role: :admin).order(updated_at: :desc).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create_admin
    @user = User.create(create_params.merge!(role: :admin))
    respond_with @user, location: users_path
  end

  def update
    @user.update(update_params)
    respond_with @user, location: users_path
  end

  def edit
  end

  def destroy
    @user.destroy
    respond_with @symptom, location: users_path
  end

  private
    def create_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :disabled)
    end

    def update_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :symptoms, :disabled)
    end

    def find_user
      @user = User.find(params[:id])
    end
end
