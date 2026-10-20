require "test_helper"

class JobApplicationTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert job_applications(:acme).valid?
  end

  test "requires a company" do
    job_application = job_applications(:acme)
    job_application.company = ""

    assert_not job_application.valid?
    assert_includes job_application.errors[:company], "can't be blank"
  end

  test "requires a user" do
    job_application = job_applications(:acme)
    job_application.user = nil

    assert_not job_application.valid?
    assert_includes job_application.errors[:user], "must exist"
  end

  test "requires a role" do
    job_application = job_applications(:acme)
    job_application.role = ""

    assert_not job_application.valid?
    assert_includes job_application.errors[:role], "can't be blank"
  end

  test "valid statuses" do
    job_application = job_applications(:acme)
    job_application.status = "banana"

    assert_not job_application.valid?
    assert_includes job_application.errors[:status], "is not included in the list"
  end

  test "allows a blank url" do
    job_application = job_applications(:acme)
    job_application.url = ""

    assert job_application.valid?
  end

  test "accepts an http(s) url" do
    job_application = job_applications(:acme)
    job_application.url = "https://example.com/job"

    assert job_application.valid?
  end

  test "rejects a url without http(s)" do
    job_application = job_applications(:acme)
    job_application.url = "not a url"

    assert_not job_application.valid?
    assert_includes job_application.errors[:url], "is invalid"
  end

  test "rejects a url containing spaces" do
    job_application = job_applications(:acme)
    job_application.url = "https://has spaces.com"

    assert_not job_application.valid?
  end

  test "new applications default to applied" do
    assert_equal "applied", JobApplication.new.status
  end
end
