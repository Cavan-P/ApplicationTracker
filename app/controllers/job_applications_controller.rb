class JobApplicationsController < ApplicationController
  def index
    @job_applications = JobApplication.order(applied_on: :desc)
  end

  def new
    @job_application = JobApplication.new
  end

  def create
    @job_application = JobApplication.new(job_application_params)

    if @job_application.save
      redirect_to job_applications_path, notice: "Application added."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def job_application_params
    params.expect(job_application: [:company, :role, :status, :applied_on, :url, :notes])
  end
end
