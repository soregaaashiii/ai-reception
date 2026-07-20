class SetupsController < ApplicationController
  STEPS = 1..6

  def show
    @step = requested_step
    @organization = current_organization
    @staff = current_organization.users.where(role: "staff").first_or_initialize
  end

  def update
    @step = requested_step
    save_step!
    next_step = [ @step + 1, STEPS.last ].min
    redirect_to setup_path(step: next_step), notice: "入力内容を保存しました。"
  rescue ActiveRecord::RecordInvalid => error
    @organization = current_organization
    @staff ||= current_organization.users.where(role: "staff").first_or_initialize
    flash.now[:alert] = error.record.errors.full_messages.to_sentence
    render :show, status: :unprocessable_content
  end

  def complete
    current_organization.update!(setup_step: 6, setup_completed_at: Time.current, reception_enabled: true)
    redirect_to root_path, notice: "初期設定が完了しました。AI受付を開始できます。"
  end

  private

  def requested_step
    params[:step].present? ? params[:step].to_i.clamp(STEPS.first, STEPS.last) : current_organization.setup_step.clamp(STEPS.first, STEPS.last)
  end

  def save_step!
    case @step
    when 1
      current_organization.update!(params.expect(organization: %i[name service_name industry]).merge(setup_step: [ current_organization.setup_step, 2 ].max))
    when 2
      attributes = params.expect(organization: %i[business_hours holidays])
      attributes[:business_days] = Array(params.dig(:organization, :business_days)).compact_blank
      current_organization.update!(attributes.merge(setup_step: [ current_organization.setup_step, 3 ].max))
    when 3
      @staff = current_organization.users.where(role: "staff").first_or_initialize
      @staff.assign_attributes(params.expect(user: %i[name email phone]))
      @staff.password = SecureRandom.base58(16) if @staff.new_record?
      @staff.role = "staff"
      @staff.save!
      current_organization.update!(setup_step: [ current_organization.setup_step, 4 ].max)
    when 4
      current_organization.update!(params.expect(organization: %i[notification_email slack_destination]).merge(setup_step: [ current_organization.setup_step, 5 ].max))
    when 5
      current_organization.update!(params.expect(organization: %i[website_url initial_faq initial_materials]).merge(setup_step: 6))
    end
  end
end
