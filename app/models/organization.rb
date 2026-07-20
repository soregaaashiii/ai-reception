class Organization < ApplicationRecord
  STATUSES = %w[trial active suspended cancelled].freeze

  has_many :locations, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :name, :service_name, :time_zone, presence: true
  validates :status, inclusion: { in: STATUSES }
end
