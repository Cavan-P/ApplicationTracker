require "test_helper"

class JobApplicationStatsTest < ActiveSupport::TestCase
  setup do
    @stats = JobApplicationStats.new(User.create_demo!.job_applications)
  end

  test "counts" do
    assert_equal 14, @stats.total
    assert_equal 7, @stats.responses
    assert_equal 5, @stats.interviews
    assert_equal 1, @stats.offers
  end

  test "rates" do
    assert_equal 50, @stats.response_rate
    assert_equal 21, @stats.ghost_rate
  end

  test "average response time" do
    assert_equal 4.3, @stats.average_response_days
  end

  test "weekly counts cover eight weeks" do
    assert_equal 8, @stats.weekly_counts.size
  end

  test "empty stats don't divide by zero" do
    stats = JobApplicationStats.new(JobApplication.none)

    assert_equal 0, stats.response_rate
    assert_nil stats.average_response_days
  end
end
