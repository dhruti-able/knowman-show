require "test_helper"

class ShowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    name = "hall-1"
    capacity = 20

    @hall = Hall.new({
      name: name,
      capacity: capacity
    })

    @hall.save
  end 
  
  test "should not save show without name, start_time, end_time, and hall" do
    show = Show.new
    assert_not show.save
  end

  test "should not save show if start_time is after end_time" do
    name = "show-1"
    start_time = DateTime.now.change({hour: 18, min: 0, sec: 0})
    end_time = DateTime.now.change({hour: 16, min: 0, sec: 0})

    show = Show.new({
      name: name,
      start_time: start_time,
      end_time: end_time,
      hall: @hall
    })

    assert_not show.save
  end

  test "should save a show if all the fields are available in valid format" do
    name = "show-1"
    start_time = DateTime.now.change({hour: 18, min: 0, sec: 0})
    end_time = DateTime.now.change({hour: 20, min: 0, sec: 0})

    show = Show.new({
      name: name,
      start_time: start_time,
      end_time: end_time,
      hall: @hall
    })

    assert show.save    
  end
end
