require "test_helper"

class HallsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.application.load_seed
  end

  test "should get index" do
    get halls_url, as: :json
    assert_response :success
  end

  test "should not create hall if not signed in" do
    post halls_url, params: { hall: { capacity: 10, name: "hall-1" } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should not create hall if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    post halls_url, params: { hall: { capacity: 10, name: "hall-1" } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should create hall if signed in a admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    assert_difference('Hall.count') do
      post halls_url, params: { hall: { capacity: 10, name: "hall-1" } }, as: :json
    end

    assert_response 201
  end

  test "should show hall" do
    get hall_url({id: 1}), as: :json
    assert_response :success
  end

  test "should not update hall if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    patch hall_url({id: 1}), params: { hall: { capacity: 10, name: "hall-1" } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should update hall if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    patch hall_url({id: 1}), params: { hall: { capacity: 10, name: "hall-1" } }, as: :json
    assert_response :success
  end

  test "should not delete hall if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    delete hall_url({id: 1}), as: :json
    assert_response :unprocessable_entity
  end

  test "should update delete if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    assert_difference('Hall.count', -1) do
      delete hall_url({id: 1}), as: :json
    end

    assert_response 204
  end
end
