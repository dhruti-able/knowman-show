require "test_helper"

class ShowsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.application.load_seed
  end

  test "should get index" do
    get hall_shows_url({ hall_id: 1 }), as: :json
    assert_response :success
  end

  test "should get show" do
    get hall_show_url({ hall_id: 1, id: 1 }), as: :json
    assert_response :success
  end

  test "should not create show if not signed in" do
    post hall_shows_url({ hall_id: 1 }), params: { 
      show: { 
        end_time: DateTime.now.change({hour: 20, min: 0, sec: 0}), 
        name: "show-2", 
        start_time: DateTime.now.change({hour: 18, min: 0, sec: 0}) 
      }
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "should not create show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    post hall_shows_url({ hall_id: 1 }), params: { 
      show: { 
        end_time: DateTime.now.change({hour: 20, min: 0, sec: 0}), 
        name: "show-2", 
        start_time: DateTime.now.change({hour: 18, min: 0, sec: 0}) 
      }
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "should create show if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    post hall_shows_url({ hall_id: 1 }), params: { 
      show: { 
        end_time: DateTime.now.change({hour: 20, min: 0, sec: 0}), 
        name: "show-2", 
        start_time: DateTime.now.change({hour: 18, min: 0, sec: 0}) 
      }
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "should not update a show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    patch hall_show_url({ id: 1, hall_id: 1 }), params: { 
      show: { 
        name: "show-2" 
      } 
    }, as: :json
    assert_response :unprocessable_entity
  end

  test "should update a show if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    patch hall_show_url({ id: 1, hall_id: 1 }), params: { 
      show: { 
        name: "show-2" 
      } 
    }, as: :json
    assert_response :success
  end

  test "should not delete a show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    delete hall_show_url({ id: 1, hall_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should delete a show if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    delete hall_show_url({ id: 1, hall_id: 1 }), as: :json
    assert_response :success
  end

  test "should not confirm a show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    get hall_show_confirm_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should not cancel a show if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    get hall_show_cancel_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should not confirm a show if total reservation < 100" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }

    # reserve 80 tickets
    8.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    get hall_show_confirm_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should not cancel a show if total reservation > 100" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }

    # reserve 110 tickets
    11.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    get hall_show_cancel_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should confirm a show if total reservation > 100 and signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }

    # reserve 110 tickets
    11.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    get hall_show_confirm_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :success
  end

  test "should not cancel a show if total reservation < 100 adn signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }

    # reserve 80 tickets
    8.times {
      post hall_show_reservations_url({ show_id: 1, hall_id: 1 }), params: { total_seats: 10 }, as: :json
    }

    get hall_show_cancel_url({ show_id: 1, hall_id: 1 }), as: :json
    assert_response :success
  end
end
