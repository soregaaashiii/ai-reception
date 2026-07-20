module ApplicationHelper
  def status_label(status)
    { "new" => "新着", "ai_completed" => "AI対応済み", "callback" => "折り返し", "in_progress" => "対応中", "appointment" => "予約", "completed" => "完了" }.fetch(status.to_s, status.to_s)
  end

  def urgency_label(urgency)
    { "low" => "低", "normal" => "通常", "high" => "高", "urgent" => "至急" }.fetch(urgency.to_s, urgency.to_s)
  end

  def channel_label(channel)
    { "phone" => "電話", "web_chat" => "Webチャット", "line" => "LINE", "email" => "メール", "form" => "問い合わせフォーム" }.fetch(channel.to_s, channel.to_s)
  end

  def status_classes(status)
    case status.to_s
    when "new", "callback" then "bg-amber-50 text-amber-800 ring-amber-200"
    when "in_progress" then "bg-blue-50 text-blue-800 ring-blue-200"
    when "completed", "ai_completed", "appointment" then "bg-emerald-50 text-emerald-800 ring-emerald-200"
    else "bg-slate-50 text-slate-700 ring-slate-200"
    end
  end

  def active_nav?(controller)
    controller_name == controller || (controller == "knowledge" && controller_name == "knowledge")
  end
end
