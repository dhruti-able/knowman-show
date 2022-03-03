class HallsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :set_hall, only: [:show, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    @halls = Hall.all

    render json: @halls
  end

  def show
    render json: @hall
  end

  def create
    @hall = Hall.new(hall_params)

    if @hall.save
      render json: @hall, status: :created
    else
      render json: @hall.errors, status: :unprocessable_entity
    end
  end

  def update
    if @hall.update(hall_params)
      render json: @hall
    else
      render json: @hall.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @hall.destroy
  end

  private
    def set_hall
      @hall = Hall.find(params[:id])
    end

    def hall_params
      params.require(:hall).permit(:name, :description, :capacity)
    end
end
