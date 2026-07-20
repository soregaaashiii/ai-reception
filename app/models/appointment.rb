class Appointment < ApplicationRecord
  belongs_to :organization
  belongs_to :location, optional: true
  belongs_to :inquiry, optional: true
  belongs_to :customer
  belongs_to :assignee, class_name: "User", optional: true
  validates :title, :starts_at, :ends_at, presence: true
end
