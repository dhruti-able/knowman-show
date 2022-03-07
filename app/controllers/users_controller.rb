class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_signin, except: [:create]
  before_action :require_admin, only: [:index]
  before_action :require_correct_user, only: [:update, :destroy]

  def index
    @users = User.all

    render json: @users
  end

  def show
    # only admin and current user should be able to view user details
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def require_correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        render json: { "@errors": "unauthorized access!" }, status: :unprocessable_entity
      end
    end
end