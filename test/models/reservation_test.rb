require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    hall_name = "hall-1"
    capacity = 15

    hall = Hall.new({
      name: hall_name,
      capacity: capacity
    })

    hall.save

    show_name = "hall-1 show-1"
    start_time = DateTime.now.change({hour: 18, min: 0, sec: 0})
    end_time = DateTime.now.change({hour: 20, min: 0, sec: 0})

    @show = Show.new({
      name: show_name,
      start_time: start_time,
      end_time: end_time,
      hall: hall
    })

    @show.save
  end 

  test "should not save reservation with out total_seats, user, and show" do
    reservation = Reservation.new
    assert_not reservation.save
  end

  test "should not save reservation if total_seats is <= 0 or > 10" do
    total_seats = -1
    
    reservation = Reservation.new({
      total_seats: total_seats,
      show: @show
    })

    assert_not reservation.save

    reservation[:total_seats] = 11

    assert_not reservation.save
  end

  test "should not save reservation if total_seats is greater than available seats at the show" do
    reservation = Reservation.new({
      total_seats: 10,
      show: @show
    })

    reservation.save

    reservation1 = Reservation.new({
      total_seats: 6,
      show: @show
    })

    assert_not reservation1.save
  end

  test "should save the reservations if all the fields are available in valid format" do
    user = User.new({
      name: "user1",
      email: "user1@knowmanshow.com",
      password: "password"
    })

    reservation = Reservation.new({
      total_seats: 8,
      show: @show,
      user: user
    })

    assert reservation.save
  end
end
