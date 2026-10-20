class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: [ :edit, :update, :destroy ]

  def index
    @job_applications = Current.user.job_applications.order(applied_on: :desc)
    @stats = JobApplicationStats.new(Current.user.job_applications)
  end

  def new
    @job_application = Current.user.job_applications.new
  end

  def create
    @job_application = Current.user.job_applications.new(job_application_params)

    if @job_application.save
      redirect_to job_applications_path, notice: "Application added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @job_application.update(job_application_params)
      redirect_to job_applications_path, notice: "Application updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @job_application.destroy!
    redirect_to job_applications_path, notice: "Application deleted.", status: :see_other
  end

  private

  def job_application_params
    params.expect(job_application: [ :company, :role, :status, :applied_on, :responded_on, :interviewed_on, :url, :notes ])
  end

  def set_job_application
    @job_application = Current.user.job_applications.find(params.expect(:id))
  end
end
