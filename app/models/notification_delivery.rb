class NotificationDelivery < ApplicationRecord
  belongs_to :organization
  belongs_to :inquiry
  validates :channel, :destination, :status, presence: true
end
