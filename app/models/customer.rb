class Customer < ApplicationRecord
  belongs_to :organization
  has_many :inquiries, dependent: :restrict_with_error
  has_many :appointments, dependent: :restrict_with_error
  validates :name, presence: true
end
