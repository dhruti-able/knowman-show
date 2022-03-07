require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.application.load_seed
  end

  test "should get index if not signed" do
    get hall_show_reservations_url({ hall_id: 1, show_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should get index if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    get hall_show_reservations_url({ hall_id: 1, show_id: 1 }), as: :json
    assert_response :success
  end

  test "should not get index if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    get hall_show_reservations_url({ hall_id: 1, show_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should get show if not signed" do
    get hall_show_reservation_url({ hall_id: 1, show_id: 1, id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should get show if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    get hall_show_reservation_url({ hall_id: 1, show_id: 1, id: 1 }), as: :json
    assert_response :success
  end

  test "should not get show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    get hall_show_reservation_url({ hall_id: 1, show_id: 1, id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should not create reservation if not signed in" do
    post hall_show_reservations_url({ hall_id: 1, show_id: 1 }), params: { reservation: { total_seats: 10 } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should create reservation if signed in" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    post hall_show_reservations_url({ hall_id: 1, show_id: 1 }), params: { reservation: { total_seats: 10 } }, as: :json
    assert_response :success
  end

  test "should create reservation if the show is cancelled" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    
    # reserve 80 tickets
    8.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    # cancel the show
    get hall_show_cancel_url({ show_id: 1, hall_id: 1 }), as: :json
    
    post hall_show_reservations_url({ hall_id: 1, show_id: 1 }), params: { reservation: { total_seats: 10 } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should create reservation if the show is sold out" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    
    # reserve 240 tickets
    24.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    post hall_show_reservations_url({ hall_id: 1, show_id: 1 }), params: { reservation: { total_seats: 10 } }, as: :json
    assert_response :unprocessable_entity
  end
end
