require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save user without name, email and password" do
    user = User.new
    assert_not user.save
  end

  test "should not save user with invalid email format" do
    name = "User 1"
    email = "user1"
    password = "password"    

    user = User.new({
      name: name,
      email: email,
      password: password
    })

    assert_not user.save
  end

  test "should save user if all the fields are available in valid format" do
    name = "User 1"
    email = "user1@knowmanshow.com"
    password = "password"

    user = User.new({
      name: name,
      email: email,
      password: password
    })

    assert user.save
  end

  test "should not save user if email is not unique" do
    name = "User 1"
    email = "user1@knowmanshow.com"
    password = "password"

    user = User.new({
      name: name,
      email: email,
      password: password
    })

    assert user.save

    name1 = "User 1"
    email1 = "User1@knowmanshow.com"
    password1 = "password"

    user1 = User.new({
      name: name1,
      email: email1,
      password: password1
    })

    assert_not user1.save
  end
end 
