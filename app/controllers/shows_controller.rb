class ShowsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :set_hall, only: [:index, :create]
  before_action :set_show, only: [:show, :update, :destroy]
  before_action :require_admin, except: [:index, :show]

  def index
    @shows = @hall.shows

    render json: @shows
  end

  def show
    render json: @show
  end

  def create
    @show = @hall.shows.new(show_params)
    
    if @show.save
      render json: @show, status: :created
    else
      render json: @show.errors, status: :unprocessable_entity
    end
  end

  def update
    if @show.update(show_params)
      render json: @show
    else
      render json: @show.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @show.destroy
  end

  # custom operations to cancel and confirm a show
  def confirm
    @show = Show.find(params[:show_id])
    if @show.cancelled?
      render json: { "@errors": "Already cancelled!" }, status: :unprocessable_entity
    elsif @show.can_confirm?
      unless @show.confirmed?
        @show.confirmed = true
        if @show.save
          render json: @show, status: :created
        else 
          render json: @show.errors, status: :unprocessable_entity
        end
      else
        render json: { "@errors": "Already confirmed!" }, status: :unprocessable_entity
      end  
    else
      render json: { "@errors": "Cannot confirm the show" }, status: :unprocessable_entity
    end
    
    # TODO: call send mail function
  end

  def cancel
    @show = Show.find(params[:show_id])
    if @show.confirmed?
      render json: { "@errors": "Already confirmed!" }, status: :unprocessable_entity
    elsif @show.can_cancel?
      unless @show.cancelled?
        @show.cancelled = true
        if @show.save
          render json: @show, status: :created
        else 
          render json: @show.errors, status: :unprocessable_entity
        end
      else
        render json: { "@errors": "Already cancelled!" }, status: :unprocessable_entity
      end  
    else
      render json: { "@errors": "Cannot cancel the show!" }, status: :unprocessable_entity
    end
    
    # TODO: call send mail function
    # TODO: call refund initiation function
  end

  private
    def set_hall
      @hall = Hall.find(params[:hall_id])
    end

    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:name, :description, :start_time, :end_time)
    end
end
