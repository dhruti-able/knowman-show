class ReservationsController < ApplicationController
  before_action :require_signin
  before_action :set_show, only: [:index, :create, :verify]
  before_action :set_reservation, only: [:show]
  before_action :require_admin, only: [:index, :show, :verify]

  def index
    @reservations = @show.reservations

    render json: @reservations
  end

  def show
    render json: @reservation
  end

  def create
    if @show.sold_out?
      render json: { "@errors": "show sold out!" }, status: :unprocessable_entity
    elsif @show.cancelled?
      render json: { "@errors": "show is cancelled!" }, status: :unprocessable_entity
    else
      Show.transaction do
        @show.lock!
        @reservation = @show.reservations.new(reservation_params)
        @reservation.user = current_user
        @reservation.seats = "#{@show.reserved_seats + 1} to #{@show.reserved_seats + reservation_params[:total_seats]}"  # TODO: change to better format

        if @reservation.save!
          render json: @reservation, status: :created
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # custom operations to verify a reservation
  def verify
    @reservation = Reservation.find(params[:reservation_id])
    if @show.cancelled?
      render json: { "@errors": "show is cancelled!" }, status: :unprocessable_entity
    else 
      unless @reservation.verified?
        @reservation.verified = true
        if @reservation.save
          render json: @reservation, status: :created
        else 
          render json: @reservation.errors, status: :unprocessable_entity
        end
      else
        render json: { "@error": "already verified!" }, status: :unprocessable_entity
      end  
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_show
      @show = Show.find(params[:show_id])
    end

    def reservation_params
      params.require(:reservation).permit(:total_seats)
    end
end
