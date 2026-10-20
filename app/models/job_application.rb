# Ruby standard is 2 space indentation I guess

class JobApplication < ApplicationRecord
  belongs_to :user

  enum :status, {
    applied: "applied",
    interviewing: "interviewing",
    offer: "offer",
    rejected: "rejected",
    ghosted: "ghosted"
  }, validate: true

  validates :company, :role, presence: true
  validates :url, format: { with: %r{\Ahttps?://\S+\z} }, allow_blank: true
end
