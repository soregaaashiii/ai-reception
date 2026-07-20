if Rails.env.development?
  organization = Organization.first_or_initialize
  organization.update!(
    name: "みどり住建株式会社", service_name: "みどり住建 AI受付", industry: "工務店",
    business_days: %w[月 火 水 木 金 土], business_hours: "9:00〜18:00", holidays: "日曜・祝日",
    notification_email: "reception@example.jp", slack_destination: "#お問い合わせ",
    website_url: "https://example.jp", initial_faq: "営業時間、対応地域、見積もりについて",
    initial_materials: "会社案内、施工事例集", setup_step: 6,
    setup_completed_at: organization.setup_completed_at || Time.current, reception_enabled: true
  )
  location = organization.locations.find_or_create_by!(name: "本社") { |record| record.primary = true }

  people = [
    ["佐藤 美咲", "owner@example.jp", "owner", "03-1234-1000"],
    ["田中 健太", "tanaka@example.jp", "staff", "03-1234-1001"],
    ["鈴木 葵", "suzuki@example.jp", "staff", "03-1234-1002"]
  ].map do |name, email, role, phone|
    organization.users.find_or_initialize_by(email:).tap do |user|
      user.assign_attributes(name:, role:, phone:, active: true)
      user.password = "password123!" if user.new_record?
      user.save!
    end
  end

  knowledge_questions = [
    ["営業時間", "営業時間を教えてください", "営業時間は月曜から土曜の9時から18時です。", "会社情報"],
    ["対応地域", "どの地域まで来てもらえますか？", "東京都内と近隣3県に対応しています。", "対応地域"],
    ["見積もり", "見積もりは無料ですか？", "現地調査とお見積もりは無料です。", "料金"],
    ["土日対応", "土日も相談できますか？", "土曜日は通常営業、日曜は事前予約で相談できます。", "営業時間"],
    ["現地調査", "現地調査にはどれくらいかかりますか？", "通常60分ほどです。", "サービス"],
    ["工期", "工事期間の目安を教えてください", "内容により異なるため、現地調査後にご案内します。", "施工"],
    ["保証", "工事後の保証はありますか？", "工事内容に応じた保証をご用意しています。", "保証"],
    ["緊急修理", "水漏れをすぐ直せますか？", "状況を確認し、最短の訪問時間をご案内します。", "緊急対応"],
    ["支払い方法", "支払い方法は何がありますか？", "銀行振込と各種ローンをご利用いただけます。", "料金"],
    ["予約変更", "予約日時を変更できますか？", "前日まで変更できます。", "予約"],
    ["キャンセル", "キャンセル料はかかりますか？", "現地調査前のキャンセル料はかかりません。", "予約"],
    ["資料請求", "施工事例集をもらえますか？", "メールまたは郵送でお送りします。", "資料"],
    ["耐震診断", "耐震診断はできますか？", "専門スタッフによる耐震診断に対応しています。", "サービス"],
    ["補助金", "補助金の相談はできますか？", "利用可能な補助金を確認してご案内します。", "料金"],
    ["施工事例", "近くの施工事例を見られますか？", "地域別の施工事例をご案内できます。", "施工"],
    ["相談方法", "オンライン相談はできますか？", "ビデオ通話での相談にも対応しています。", "サービス"],
    ["駐車場", "駐車場はありますか？", "本社にお客様用駐車場が3台あります。", "店舗情報"],
    ["担当エリア", "担当者は地域ごとに違いますか？", "地域と工事内容に合わせて担当者を決定します。", "会社情報"],
    ["定期点検", "定期点検はありますか？", "施工後1年、3年、5年の点検を行います。", "保証"],
    ["相談時間", "相談にはどのくらい時間がかかりますか？", "初回相談は45分ほどです。", "サービス"]
  ]
  knowledge = knowledge_questions.map.with_index do |(title, question, answer, category), index|
    organization.knowledge_items.find_or_create_by!(title:) do |item|
      item.assign_attributes(question:, answer:, category:, source: "初期FAQ", usage_count: 12 + index * 2, resolution_count: 8 + index)
    end
  end

  names = %w[高橋 伊藤 渡辺 山本 中村 小林 加藤 吉田 山田 佐々木 山口 松本 井上 木村 林 清水 山崎 森 池田 橋本]
  statuses = %w[callback new ai_completed in_progress appointment completed]
  channels = %w[phone phone phone web_chat line email form]
  categories = %w[見積もり 予約 施工 対応地域 緊急修理 資料請求]
  30.times do |index|
    customer = organization.customers.find_or_create_by!(phone: "090-#{format('%04d', 1200 + index)}-#{format('%04d', 4500 + index)}") do |record|
      record.name = "#{names[index % names.length]} #{%w[一郎 美咲 健太 葵 翔][index % 5]}"
      record.email = "customer#{index + 1}@example.jp"
    end
    inquiry = organization.inquiries.find_or_initialize_by(customer:, received_at: (index.hours.ago.change(min: index % 60)))
    inquiry.assign_attributes(
      location:, assignee: people[index % people.length], channel: channels[index % channels.length],
      status: statuses[index % statuses.length], urgency: index % 9 == 0 ? "urgent" : index % 4 == 0 ? "high" : "normal",
      lead_level: index % 3 == 0 ? "high" : "medium", category: categories[index % categories.length],
      summary: ["外壁リフォームの見積もりを希望", "来週の現地調査を予約したい", "対応地域と費用を確認", "水漏れの緊急修理を希望", "施工事例集の送付を希望"][index % 5],
      customer_request: "担当者から具体的な日程と費用を案内してほしい",
      next_action: statuses[index % statuses.length] == "callback" ? "本日中に折り返す" : "内容を確認して回答する",
      transcript: "お電話ありがとうございます。AI受付がご用件を承ります。\nリフォームの見積もりについて相談したいです。\n承知しました。ご希望の内容を確認します。",
      recording_name: "通話録音 #{index + 1}", recording_duration_seconds: 160 + index * 3,
      unanswered_portion: index % 5 == 0 ? "特注素材の正確な納期" : nil,
      outside_business_hours: index % 6 == 0, ai_completed: statuses[index % statuses.length] == "ai_completed",
      conversion_stage: index % 10 == 0 ? "contract" : index % 4 == 0 ? "meeting" : nil,
      revenue_yen: index % 10 == 0 ? 850_000 + index * 10_000 : 0
    )
    inquiry.save!
    if inquiry.messages.empty?
      inquiry.messages.create!(organization:, speaker: "customer", content: "#{inquiry.category}について相談したいです。", spoken_at: inquiry.received_at)
      inquiry.messages.create!(organization:, speaker: "ai", content: knowledge[index % knowledge.length].answer, spoken_at: inquiry.received_at + 30.seconds)
    end
    InquiryKnowledgeUse.find_or_create_by!(organization:, inquiry:, knowledge_item: knowledge[index % knowledge.length])
    inquiry.notification_deliveries.find_or_create_by!(organization:, channel: "email", destination: organization.notification_email, status: "sent", delivered_at: inquiry.received_at + 2.minutes)
  end

  organization.inquiries.limit(10).each_with_index do |inquiry, index|
    organization.appointments.find_or_create_by!(inquiry:) do |appointment|
      appointment.assign_attributes(location:, customer: inquiry.customer, assignee: inquiry.assignee, title: "現地調査", starts_at: Time.zone.now.beginning_of_day + (index + 1).days + 10.hours, ends_at: Time.zone.now.beginning_of_day + (index + 1).days + 11.hours)
    end
  end

  candidate_questions = [
    ["夜間でも緊急修理できますか？", ["夜中の水漏れに来てもらえますか？", "24時間対応ですか？"], "状況を確認し、夜間対応可能な担当者から折り返します。"],
    ["土日でも見積もりできますか？", ["日曜日も来てもらえますか？", "休日に現地調査できますか？"], "土曜日は通常対応、日曜日は事前予約で対応しています。"],
    ["リフォームローンの金利は？", ["分割払いの利率を教えて", "ローン相談はできますか？"], "提携ローンの最新条件を担当者からご案内します。"],
    ["ペットがいても工事できますか？", ["犬がいる家でも大丈夫？", "工事中の猫の安全は？"], "安全な作業区画をご相談のうえ工事します。"],
    ["古民家の改修実績はありますか？", ["築100年でも直せますか？"], "建物の状態を確認してご案内します。"],
    ["近所への挨拶はしてもらえますか？", ["工事前の近隣対応は？"], "着工前に担当者が近隣へご挨拶します。"],
    ["工事中も住めますか？", ["仮住まいは必要？"], "工事範囲により異なるため現地調査後にご案内します。"],
    ["写真だけで見積もれますか？", ["LINEで写真を送れば金額が分かる？"], "概算は可能ですが正式見積もりには現地調査が必要です。"],
    ["相見積もりでも相談できますか？", ["他社と比較してもいい？"], "相見積もりでもお気軽にご相談ください。"],
    ["工事音は何時までですか？", ["騒音が出る時間帯は？"], "原則8時30分から17時まで作業します。"]
  ]
  candidate_questions.each_with_index do |(question, similar, answer), index|
    organization.improvement_candidates.find_or_create_by!(representative_question: question) do |candidate|
      candidate.assign_attributes(similar_questions: similar, draft_answer: answer, category: categories[index % categories.length], inquiry_count: 42 - index * 3, unanswered_count: 18 - index, growth_rate: 28 - index * 2, sales_impact: index < 3 ? "high" : "medium")
    end
  end
end
