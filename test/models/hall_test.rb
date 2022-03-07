require "test_helper"

class HallTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save hall without name and capacity" do
    hall = Hall.new
    assert_not hall.save
  end

  test "should not save hall if capacity is <= 0" do
    name = "hall-1"
    capacity = -1

    hall = Hall.new({
      name: name,
      capacity: capacity
    })

    assert_not hall.save
  end

  test "should not save hall if capacity is not an integer" do
    name = "hall-1"
    capacity = 10.5

    hall = Hall.new({
      name: name,
      capacity: capacity
    })

    assert_not hall.save
  end

  test "should save hall if all the fields are available in valid format" do
    name= "hall-1"
    capacity = 200

    hall = Hall.new({
      name: name,
      capacity: capacity
    })

    assert hall.save
  end
end
