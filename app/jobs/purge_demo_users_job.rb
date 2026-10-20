class PurgeDemoUsersJob < ApplicationJob
  queue_as :default

  def perform
    User.where(demo: true).where(created_at: ...1.day.ago).destroy_all
  end
end
