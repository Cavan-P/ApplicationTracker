require "test_helper"

class DemoSessionsControllerTest < ActionDispatch::IntegrationTest
  test "creates a demo user with sample data and signs in" do
    assert_difference "User.count", 1 do
      post demo_session_path
    end

    assert_redirected_to root_path
    assert User.last.demo?
    assert_equal User.demo_applications.size, User.last.job_applications.count
  end
end
