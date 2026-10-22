class JobApplicationStats
  WEEKS_SHOWN = 8

  attr_reader :weeks_ago

  def initialize(job_applications, weeks_ago: 0)
    @job_applications = job_applications
    @weeks_ago = weeks_ago
  end

  def total
    @total ||= @job_applications.count
  end

  def active
    @job_applications.where(status: %w[ applied interviewing ]).count
  end

  def responses
    @job_applications.where(status: %w[ interviewing offer rejected ])
      .or(@job_applications.where.not(responded_on: nil)).count
  end

  def interviews
    @job_applications.where.not(interviewed_on: nil).count
  end

  def offers
    @job_applications.offer.count
  end

  def response_rate
    percent(responses)
  end

  def interview_rate
    percent(interviews)
  end

  def offer_rate
    percent(offers)
  end

  def rejection_rate
    percent(@job_applications.rejected.count)
  end

  def ghost_rate
    percent(@job_applications.ghosted.count)
  end

  def average_response_days
    days = @job_applications
      .where.not(applied_on: nil).where.not(responded_on: nil)
      .pluck(:applied_on, :responded_on)
      .map { |applied, responded| (responded - applied).to_i }
    return if days.empty?

    (days.sum.to_f / days.size).round(1)
  end

  def this_week
    @job_applications.where(applied_on: Date.current.beginning_of_week..).count
  end

  def per_week
    first = @job_applications.minimum(:applied_on)
    return 0 if first.nil?

    weeks = [ (Date.current - first).to_i / 7.0, 1 ].max
    (@job_applications.where.not(applied_on: nil).count / weeks).round(1)
  end

  def weekly_counts
    counts = @job_applications.where(applied_on: chart_start...(chart_end + 1.week)).pluck(:applied_on)
      .group_by(&:beginning_of_week).transform_values(&:size)

    (0...WEEKS_SHOWN).map do |i|
      week = chart_start + i.weeks
      [ week, counts.fetch(week, 0) ]
    end
  end

  def older_weeks?
    @job_applications.where(applied_on: ...chart_start).exists?
  end

  def status_counts
    JobApplication.statuses.keys.index_with(0).merge(@job_applications.group(:status).count)
  end

  def percent(count)
    return 0 if total.zero?

    (count * 100.0 / total).round
  end

  private

  def chart_end
    Date.current.beginning_of_week - @weeks_ago.weeks
  end

  def chart_start
    chart_end - (WEEKS_SHOWN - 1).weeks
  end
end
