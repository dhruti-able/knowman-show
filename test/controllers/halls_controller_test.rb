require "test_helper"

class HallsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hall = halls(:one)
  end

  test "should get index" do
    get halls_url, as: :json
    assert_response :success
  end

  test "should create hall" do
    assert_difference('Hall.count') do
      post halls_url, params: { hall: { capacity: @hall.capacity, description: @hall.description, name: @hall.name } }, as: :json
    end

    assert_response 201
  end

  test "should show hall" do
    get hall_url(@hall), as: :json
    assert_response :success
  end

  test "should update hall" do
    patch hall_url(@hall), params: { hall: { capacity: @hall.capacity, description: @hall.description, name: @hall.name } }, as: :json
    assert_response 200
  end

  test "should destroy hall" do
    assert_difference('Hall.count', -1) do
      delete hall_url(@hall), as: :json
    end

    assert_response 204
  end
end
