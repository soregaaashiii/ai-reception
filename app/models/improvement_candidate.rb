class ImprovementCandidate < ApplicationRecord
  belongs_to :organization
  belongs_to :source_message, class_name: "Message", optional: true
  validates :representative_question, :draft_answer, :category, presence: true
end
