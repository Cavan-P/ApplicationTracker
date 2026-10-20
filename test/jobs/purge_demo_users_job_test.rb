require "test_helper"

class PurgeDemoUsersJobTest < ActiveJob::TestCase
  test "remove old demo user but keep new and real users" do
    old = User.create_demo!
    old.update!(created_at: 2.days.ago)
    fresh = User.create_demo!
    real = users(:one)

    PurgeDemoUsersJob.perform_now

    assert_not User.exists?(old.id)
    assert User.exists?(fresh.id)
    assert User.exists?(real.id)
  end
end
