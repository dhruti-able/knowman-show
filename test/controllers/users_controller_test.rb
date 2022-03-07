require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    Rails.application.load_seed
  end

  test "should get index if not signed" do
    get users_url, as: :json
    assert_response :unprocessable_entity
  end

  test "should get index if signed in as admin user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    get users_url, as: :json
    assert_response :success
  end

  test "should not get index if not signed in as admin user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    get users_url, as: :json
    assert_response :unprocessable_entity
  end

  test "should create user" do
    assert_difference('User.count') do
      post signup_url, params: { user: { email: "user1@knowmanshow.com", name: "user1", password: 'password', password_confirmation: 'password' } }, as: :json
    end

    assert_response 201
  end

  test "should show user if signed in with correct user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    
    get user_path(user), as: :json
    user = @response.parsed_body

    assert_response :success
    assert_equal(user["name"], "public")
  end

  test "should not update user if not signed in" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    delete signout_path(user)

    patch user_url(user), params: { user: { email: "public@knowmanshow.com", name: "public", password: 'password', password_confirmation: 'password' } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should not update user if not signed in as correct user" do
    # sign in with public
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    
    # try to update admin user
    patch user_url({ id: 1 }), params: { user: { email: "public@knowmanshow.com", name: "public", password: 'password', password_confirmation: 'password' } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should update user if a valid user has signed in" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    
    patch user_url(user), params: { user: { email: "public@knowmanshow.com", name: "public1", password: 'password', password_confirmation: 'password' } }, as: :json
    assert_response :success
  end

  test "should not delete user if not signed in" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    delete signout_path(user)

    delete user_url(user), as: :json
    assert_response :unprocessable_entity
  end

  test "should not delete user if not signed in as correct user" do
    # sign in with public
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    
    # try to update admin user
    delete user_url({ id: 1 }), as: :json
    assert_response :unprocessable_entity
  end

  test "should delete user if valid a user has signed in" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    
    assert_difference('User.count', -1) do
      delete user_url(user), as: :json
    end

    assert_response 204
  end
end
