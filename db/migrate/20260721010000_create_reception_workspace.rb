class CreateReceptionWorkspace < ActiveRecord::Migration[8.1]
  def change
    change_table :organizations do |t|
      t.string :industry
      t.jsonb :business_days, null: false, default: %w[月 火 水 木 金]
      t.string :business_hours, null: false, default: "9:00〜18:00"
      t.text :holidays
      t.string :notification_email
      t.string :slack_destination
      t.string :website_url
      t.text :initial_faq
      t.text :initial_materials
      t.integer :setup_step, null: false, default: 1
      t.datetime :setup_completed_at
      t.boolean :reception_enabled, null: false, default: false
    end
    add_column :users, :phone, :string

    create_table :customers do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone
      t.string :email
      t.timestamps
    end
    add_index :customers, %i[organization_id phone]

    create_table :inquiries do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :location, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :channel, null: false
      t.string :status, null: false, default: "new"
      t.string :urgency, null: false, default: "normal"
      t.string :lead_level, null: false, default: "medium"
      t.string :category, null: false
      t.text :summary, null: false
      t.text :customer_request
      t.text :next_action
      t.text :transcript
      t.string :recording_name
      t.integer :recording_duration_seconds
      t.text :unanswered_portion
      t.boolean :outside_business_hours, null: false, default: false
      t.boolean :ai_completed, null: false, default: false
      t.datetime :received_at, null: false
      t.string :conversion_stage
      t.integer :revenue_yen, null: false, default: 0
      t.timestamps
    end
    add_index :inquiries, %i[organization_id status]
    add_index :inquiries, %i[organization_id received_at]

    create_table :messages do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :inquiry, null: false, foreign_key: true
      t.string :speaker, null: false
      t.text :content, null: false
      t.datetime :spoken_at, null: false
      t.timestamps
    end

    create_table :knowledge_items do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :title, null: false
      t.text :question, null: false
      t.text :answer, null: false
      t.string :category, null: false
      t.string :status, null: false, default: "published"
      t.text :source, null: false
      t.integer :usage_count, null: false, default: 0
      t.integer :resolution_count, null: false, default: 0
      t.timestamps
    end

    create_table :inquiry_knowledge_uses do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :inquiry, null: false, foreign_key: true
      t.references :knowledge_item, null: false, foreign_key: true
      t.timestamps
    end
    add_index :inquiry_knowledge_uses, %i[inquiry_id knowledge_item_id], unique: true

    create_table :improvement_candidates do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :source_message, foreign_key: { to_table: :messages }
      t.text :representative_question, null: false
      t.jsonb :similar_questions, null: false, default: []
      t.text :draft_answer, null: false
      t.string :category, null: false
      t.integer :inquiry_count, null: false, default: 0
      t.integer :unanswered_count, null: false, default: 0
      t.decimal :growth_rate, null: false, default: 0
      t.string :sales_impact, null: false, default: "medium"
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    create_table :knowledge_histories do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :knowledge_item, foreign_key: true
      t.string :action, null: false
      t.string :actor_name, null: false
      t.text :summary, null: false
      t.timestamps
    end

    create_table :appointments do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :location, foreign_key: true
      t.references :inquiry, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.string :status, null: false, default: "confirmed"
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.timestamps
    end

    create_table :notification_deliveries do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :inquiry, null: false, foreign_key: true
      t.string :channel, null: false
      t.string :destination, null: false
      t.string :status, null: false
      t.datetime :delivered_at
      t.text :error_message
      t.timestamps
    end
  end
end
