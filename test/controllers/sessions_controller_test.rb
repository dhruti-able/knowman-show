require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    Rails.application.load_seed
  end

  test "should not sign in with unknown user" do
    post signin_url, params: { email: "public1@knowmanshow.com", password: "password" }
    get users_url, as: :json
    assert_response :unprocessable_entity
  end

  test "should sign in with known user" do
    post signin_url, params: { email: "admin@knowmanshow.com", password: "password" }
    user = @response.parsed_body

    assert_equal(user, 1)
    assert_response :success
  end

  test "should sign out with known user" do
    post signin_url, params: { email: "public@knowmanshow.com", password: "password" }
    user = @response.parsed_body
    delete signout_path(user)

    assert_response :success
  end
end
