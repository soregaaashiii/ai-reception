class InquiriesController < ApplicationController
  before_action :set_inquiry, only: %i[show update knowledge_draft]

  def index
    @inquiries = current_organization.inquiries.includes(:customer, :assignee)
    @inquiries = @inquiries.where(status: params[:status]) if params[:status].in?(Inquiry::STATUSES)
    @inquiries = @inquiries.where(assignee_id: params[:assignee_id]) if params[:assignee_id].present?
    @inquiries = @inquiries.where(channel: params[:channel]) if params[:channel].in?(Inquiry::CHANNELS)
    @inquiries = @inquiries.where(received_at: Date.parse(params[:from]).beginning_of_day..) if params[:from].present?
    @inquiries = sort_scope(@inquiries)
    @assignees = current_organization.users.where(role: %w[owner admin staff]).order(:name)
  rescue Date::Error
    redirect_to inquiries_path, alert: "期間を正しく入力してください。"
  end

  def show
    @messages = @inquiry.messages.order(:spoken_at)
    @assignees = current_organization.users.where(role: %w[owner admin staff]).order(:name)
  end

  def update
    return deny_write if current_user.read_only?
    @inquiry.update!(params.expect(inquiry: %i[status assignee_id]))
    redirect_to inquiry_path(@inquiry), notice: "問い合わせを更新しました。"
  end

  def knowledge_draft
    return deny_write if current_user.read_only?
    message = @inquiry.messages.find(params[:message_id])
    candidate = current_organization.improvement_candidates.create!(
      source_message: message, representative_question: message.content,
      similar_questions: [], draft_answer: "回答内容を入力してください。",
      category: @inquiry.category, inquiry_count: 1, unanswered_count: 1
    )
    redirect_to knowledge_index_path(candidate_id: candidate.id), notice: "発言から改善候補を作成しました。"
  end

  private

  def set_inquiry
    @inquiry = current_organization.inquiries.find(params[:id])
  end

  def sort_scope(scope)
    case params[:sort]
    when "urgency" then scope.order(Arel.sql("CASE urgency WHEN 'urgent' THEN 0 WHEN 'high' THEN 1 WHEN 'normal' THEN 2 ELSE 3 END"), received_at: :desc)
    when "action" then scope.order(Arel.sql("CASE status WHEN 'callback' THEN 0 WHEN 'new' THEN 1 WHEN 'in_progress' THEN 2 ELSE 3 END"), received_at: :desc)
    when "lead" then scope.order(Arel.sql("CASE lead_level WHEN 'high' THEN 0 WHEN 'medium' THEN 1 ELSE 2 END"), received_at: :desc)
    else scope.order(received_at: :desc)
    end
  end

  def deny_write
    redirect_back fallback_location: inquiries_path, alert: "閲覧のみの権限では変更できません。"
  end
end
