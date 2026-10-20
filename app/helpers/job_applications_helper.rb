module JobApplicationsHelper
  STATUS_CLASSES = {
    "applied" => "bg-sky-500/15 text-sky-300 ring-1 ring-sky-500/30",
    "interviewing" => "bg-violet-500/15 text-violet-300 ring-1 ring-violet-500/30",
    "offer" => "bg-emerald-500/15 text-emerald-300 ring-1 ring-emerald-500/30",
    "rejected" => "bg-rose-500/15 text-rose-300 ring-1 ring-rose-500/30",
    "ghosted" => "bg-zinc-500/15 text-zinc-400 ring-1 ring-zinc-500/30"
  }.freeze

  STATUS_CHART_COLORS = {
    "applied" => { dot: "bg-sky-400", stroke: "stroke-sky-400" },
    "interviewing" => { dot: "bg-violet-400", stroke: "stroke-violet-400" },
    "offer" => { dot: "bg-emerald-400", stroke: "stroke-emerald-400" },
    "rejected" => { dot: "bg-rose-400", stroke: "stroke-rose-400" },
    "ghosted" => { dot: "bg-zinc-500", stroke: "stroke-zinc-500" }
  }.freeze

  def status_badge(job_application)
    tag.span job_application.status.humanize,
      class: "rounded-full px-2.5 py-0.5 text-xs font-medium #{STATUS_CLASSES.fetch(job_application.status)}"
  end
end
