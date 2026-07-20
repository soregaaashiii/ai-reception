class KnowledgeItem < ApplicationRecord
  belongs_to :organization
  has_many :inquiry_knowledge_uses, dependent: :destroy
  has_many :inquiries, through: :inquiry_knowledge_uses
  has_many :knowledge_histories, dependent: :nullify
  validates :title, :question, :answer, :category, :source, presence: true
end
