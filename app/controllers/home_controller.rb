class HomeController < ApplicationController
  def show
    @organization = current_organization
    today = Time.zone.today.all_day
    @today_inquiries = current_organization.inquiries.where(received_at: today)
    @today_appointments = current_organization.appointments.where(starts_at: today)
    @tasks = current_organization.inquiries.needs_action.includes(:customer, :assignee).order(
      Arel.sql("CASE status WHEN 'callback' THEN 0 WHEN 'new' THEN 1 WHEN 'in_progress' THEN 2 ELSE 3 END"),
      received_at: :asc
    ).limit(6)
    @new_questions = current_organization.improvement_candidates.where(status: "pending").count
  end
end
