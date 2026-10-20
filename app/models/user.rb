class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :job_applications, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.create_demo!
    transaction do
      user = create!(
        email_address: "demo-#{SecureRandom.hex(6)}@demo.invalid",
        password: SecureRandom.base58(24),
        demo: true
      )
      user.job_applications.create!(demo_applications)
      user
    end
  end

  def self.demo_applications
    [
      { company: "Nimbus Labs", role: "Junior Rails Developer", status: "interviewing", applied_on: 12.days.ago, url: "https://example.com/jobs/1" },
      { company: "Brightwave", role: "Full-Stack Engineer", status: "applied", applied_on: 3.days.ago },
      { company: "Copperline", role: "Backend Engineer", status: "offer", applied_on: 30.days.ago, notes: "Offer call Friday" },
      { company: "Driftwood Games", role: "Gameplay Programmer", status: "rejected", applied_on: 21.days.ago },
      { company: "Lumen Health", role: "Software Engineer I", status: "ghosted", applied_on: 45.days.ago },
      { company: "Parcel & Pine", role: "Web Developer", status: "applied", applied_on: 1.day.ago }
    ]
  end
end
