class Message < ApplicationRecord
  SPEAKERS = %w[customer ai staff].freeze
  belongs_to :organization
  belongs_to :inquiry
  validates :content, :spoken_at, presence: true
  validates :speaker, inclusion: { in: SPEAKERS }
end
