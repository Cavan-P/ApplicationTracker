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
    today = Date.current
    [
      { company: "Nimbus Labs", role: "Junior Rails Developer", status: "interviewing", applied_on: today - 12, responded_on: today - 8, interviewed_on: today - 4, url: "https://example.com/jobs/1" },
      { company: "Brightwave", role: "Full-Stack Engineer", status: "applied", applied_on: today - 3 },
      { company: "Copperline", role: "Backend Engineer", status: "offer", applied_on: today - 30, responded_on: today - 25, interviewed_on: today - 20, notes: "Offer call Friday" },
      { company: "Driftwood Games", role: "Gameplay Programmer", status: "rejected", applied_on: today - 21, responded_on: today - 14 },
      { company: "Lumen Health", role: "Software Engineer I", status: "ghosted", applied_on: today - 45 },
      { company: "Parcel & Pine", role: "Web Developer", status: "applied", applied_on: today - 1 },
      { company: "Harbor Analytics", role: "Data Engineer", status: "rejected", applied_on: today - 38, responded_on: today - 33, interviewed_on: today - 30 },
      { company: "Quillstone", role: "Ruby on Rails Developer", status: "interviewing", applied_on: today - 9, responded_on: today - 6, interviewed_on: today - 2 },
      { company: "Orbit Commerce", role: "Frontend Developer", status: "ghosted", applied_on: today - 52 },
      { company: "Tallgrass Software", role: "Associate Engineer", status: "rejected", applied_on: today - 17, responded_on: today - 15 },
      { company: "Pixelforge Studios", role: "Tools Programmer", status: "applied", applied_on: today - 6 },
      { company: "Meridian Bank", role: "Software Developer", status: "ghosted", applied_on: today - 27 },
      { company: "Fernway", role: "Platform Engineer", status: "interviewing", applied_on: today - 15, responded_on: today - 11, interviewed_on: today - 7 },
      { company: "Sundial Apps", role: "Mobile Developer", status: "applied", applied_on: today }
    ]
  end
end
