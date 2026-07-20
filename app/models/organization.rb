class Organization < ApplicationRecord
  STATUSES = %w[trial active suspended cancelled].freeze

  has_many :locations, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :knowledge_items, dependent: :destroy
  has_many :improvement_candidates, dependent: :destroy
  has_many :knowledge_histories, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :notification_deliveries, dependent: :destroy

  validates :name, :service_name, :time_zone, presence: true
  validates :status, inclusion: { in: STATUSES }

  def setup_complete?
    setup_completed_at.present?
  end
end
