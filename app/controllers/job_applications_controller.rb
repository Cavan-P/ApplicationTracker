class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: [ :edit, :update, :destroy ]

  PER_PAGE = 25
  SORTS = {
    "newest" => { applied_on: :desc, id: :desc },
    "oldest" => { applied_on: :asc, id: :asc },
    "company" => { company: :asc, id: :asc }
  }.freeze

  helper_method :filter_params

  def index
    applications = Current.user.job_applications
    @stats = JobApplicationStats.new(applications, weeks_ago: params[:weeks_ago].to_i.clamp(0, 520))

    scope = applications
    scope = scope.where(status: params[:status]) if JobApplication.statuses.key?(params[:status])
    if params[:q].present?
      term = "%#{JobApplication.sanitize_sql_like(params[:q].strip)}%"
      scope = scope.where("company LIKE :term OR role LIKE :term", term: term)
    end
    scope = scope.order(SORTS.fetch(params[:sort], SORTS["newest"]))

    @total_count = scope.count
    @total_pages = [ (@total_count / PER_PAGE.to_f).ceil, 1 ].max
    @page = params[:page].to_i.clamp(1, @total_pages)
    @job_applications = scope.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
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

  def filter_params
    { q: params[:q], status: params[:status], sort: params[:sort] }.compact_blank
  end
end
