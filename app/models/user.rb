class User < ApplicationRecord
  ROLES = %w[owner admin staff viewer].freeze

  belongs_to :organization
  has_secure_password

  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }

  def can_manage_settings?
    role.in?(%w[owner admin])
  end

  def read_only?
    role == "viewer"
  end
end
