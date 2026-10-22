require "test_helper"

class JobApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_application = job_applications(:acme)
  end

  test "redirects to sign in when logged out" do
    get job_applications_path

    assert_redirected_to new_session_path
  end

  test "lists applications when signed in" do
    sign_in_as users(:one)
    get job_applications_path

    assert_response :success
    assert_select "td", "Acme Corp"
  end

  test "creates an application" do
    sign_in_as users(:one)

    # count records before and after the block; it must go up by exactly 1
    assert_difference "JobApplication.count", 1 do
      post job_applications_path, params: { job_application: { company: "Initech", role: "Developer" } }
    end
    assert_redirected_to job_applications_path
  end

  test "does not create an invalid application" do
    sign_in_as users(:one)

    assert_no_difference "JobApplication.count" do
      post job_applications_path, params: { job_application: { company: "", role: "Developer" } }
    end
    assert_response :unprocessable_content
  end

  test "updates an application" do
    sign_in_as users(:one)

    patch job_application_path(@job_application), params: { job_application: { company: "Acme Inc" } }

    assert_redirected_to job_applications_path
    # @job_application still holds the old values in memory; reload re-reads them from the database
    assert_equal "Acme Inc", @job_application.reload.company
  end

  test "deletes an application" do
    sign_in_as users(:one)

    assert_difference "JobApplication.count", -1 do
      delete job_application_path(@job_application)
    end
  end

  test "cannot create when logged out" do
    assert_no_difference "JobApplication.count" do
      post job_applications_path, params: { job_application: { company: "A", role: "Developer" } }
    end

    assert_redirected_to new_session_path
  end

  test "does not list another user's applications" do
    sign_in_as users(:one)
    get job_applications_path

    assert_select "td", text: "Acme Corp"
    assert_select "td", text: "Globex", count: 0
  end

  test "cannot edit another user's application" do
    sign_in_as users(:one)
    get edit_job_application_path(job_applications(:globex))

    assert_response :not_found
  end

  test "filters by status" do
    sign_in_as users(:one)
    get job_applications_path(status: "rejected")

    assert_select "td", text: "Acme Corp", count: 0
  end

  test "searches company and role" do
    sign_in_as users(:one)
    get job_applications_path(q: "acm")

    assert_select "td", text: "Acme Corp"
  end

  test "paginates" do
    user = users(:one)
    30.times { |i| user.job_applications.create!(company: "Company #{i}", role: "Dev", applied_on: Date.current) }
    sign_in_as user
    get job_applications_path(page: 2)

    assert_select "tbody tr", 6
  end
end
