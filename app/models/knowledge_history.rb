class KnowledgeHistory < ApplicationRecord
  belongs_to :organization
  belongs_to :knowledge_item, optional: true
  validates :action, :actor_name, :summary, presence: true
end
