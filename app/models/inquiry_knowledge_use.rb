class InquiryKnowledgeUse < ApplicationRecord
  belongs_to :organization
  belongs_to :inquiry
  belongs_to :knowledge_item
  validates :knowledge_item_id, uniqueness: { scope: :inquiry_id }
end
