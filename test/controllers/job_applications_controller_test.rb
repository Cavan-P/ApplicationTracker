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

  # YOUR TURN 1: "deletes an application"
  #   - sign in
  #   - like "creates", but the count should change by -1
  #   - the request is: delete job_application_path(@job_application)
  test "deletes an application" do
    sign_in_as users(:one)

    assert_difference "JobApplication.count", -1 do
      delete job_application_path(@job_application)
    end
  end

  # YOUR TURN 2: "cannot create when logged out"
  #   - do NOT sign in
  #   - like "does not create an invalid application", but with VALID params
  #   - then assert it redirected to the sign-in page

  test "cannot create when logged out" do
    assert_no_difference "JobApplication.count" do
      post job_applications_path, params: { job_application: { company: "A", role: "Developer" } }
    end

    assert_redirected_to new_session_path
  end
end
