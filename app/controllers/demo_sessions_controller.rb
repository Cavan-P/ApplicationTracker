class DemoSessionsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 5, within: 1.minute, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def create
    start_new_session_for User.create_demo!
    redirect_to root_path, notice: "Welcome to the demo! Your changes are private and reset after a day."
  end
end
