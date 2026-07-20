class KnowledgeController < ApplicationController
  before_action :require_knowledge_manager, only: %i[approve merge postpone create]

  def index
    @tab = params[:tab].presence_in(%w[candidates registered history]) || "candidates"
    @sort = params[:sort].presence_in(%w[count unanswered growth sales]) || "unanswered"
    @candidates = sort_candidates(current_organization.improvement_candidates.where(status: %w[pending later]))
    @items = current_organization.knowledge_items.order(updated_at: :desc)
    @histories = current_organization.knowledge_histories.order(created_at: :desc)
    @selected_candidate = @candidates.find_by(id: params[:candidate_id])
  end

  def approve
    candidate = current_organization.improvement_candidates.find(params[:id])
    item = current_organization.knowledge_items.create!(
      title: candidate.representative_question.truncate(40),
      question: params[:question].presence || candidate.representative_question,
      answer: params[:answer].presence || candidate.draft_answer,
      category: candidate.category, source: "改善候補から承認"
    )
    candidate.update!(status: "approved")
    current_organization.knowledge_histories.create!(knowledge_item: item, action: "登録", actor_name: current_user.name, summary: "改善候補を確認して登録")
    redirect_to knowledge_index_path(tab: "registered"), notice: "AIの知識を登録しました。次回から回答に使用できます。"
  end

  def postpone
    current_organization.improvement_candidates.find(params[:id]).update!(status: "later")
    redirect_to knowledge_index_path, notice: "後で確認する候補に移動しました。"
  end

  def merge
    candidate = current_organization.improvement_candidates.find(params[:id])
    item = current_organization.knowledge_items.find(params[:knowledge_item_id])
    item.update!(question: [item.question, candidate.representative_question].compact_blank.join("\n類似質問: "))
    candidate.update!(status: "approved")
    current_organization.knowledge_histories.create!(knowledge_item: item, action: "統合", actor_name: current_user.name, summary: "改善候補の類似質問を既存の知識へ統合")
    redirect_to knowledge_index_path(tab: "registered"), notice: "改善候補を既存の知識へ統合しました。"
  end

  def create
    item = current_organization.knowledge_items.create!(params.expect(knowledge_item: %i[title question answer category source]))
    current_organization.knowledge_histories.create!(knowledge_item: item, action: "登録", actor_name: current_user.name, summary: "手動で登録")
    redirect_to knowledge_index_path(tab: "registered"), notice: "AIの知識を登録しました。"
  end

  private

  def require_knowledge_manager
    return if current_user.can_manage_settings?
    redirect_to knowledge_index_path, alert: "知識の登録には管理者以上の権限が必要です。"
  end

  def sort_candidates(scope)
    case @sort
    when "count" then scope.order(inquiry_count: :desc)
    when "growth" then scope.order(growth_rate: :desc)
    when "sales" then scope.order(Arel.sql("CASE sales_impact WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END"))
    else scope.order(unanswered_count: :desc)
    end
  end
end
