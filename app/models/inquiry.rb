class Inquiry < ApplicationRecord
  STATUSES = %w[new ai_completed callback in_progress appointment completed].freeze
  CHANNELS = %w[phone web_chat line email form].freeze
  URGENCIES = %w[low normal high urgent].freeze

  belongs_to :organization
  belongs_to :location, optional: true
  belongs_to :customer
  belongs_to :assignee, class_name: "User", optional: true
  has_many :messages, dependent: :destroy
  has_many :appointments, dependent: :nullify
  has_many :notification_deliveries, dependent: :destroy
  has_many :inquiry_knowledge_uses, dependent: :destroy
  has_many :knowledge_items, through: :inquiry_knowledge_uses

  validates :summary, :category, :received_at, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :channel, inclusion: { in: CHANNELS }
  validates :urgency, inclusion: { in: URGENCIES }

  scope :needs_action, -> { where(status: %w[new callback in_progress]) }
end
