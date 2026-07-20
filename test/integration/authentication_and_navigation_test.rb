require "test_helper"

class AuthenticationAndNavigationTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.create!(name: "試験会社", service_name: "試験AI受付")
    @user = @organization.users.create!(name: "試験 太郎", email: "test@example.jp", password: "password123!", role: "owner")
  end

  test "未ログインではログイン画面へ移動する" do
    get root_path
    assert_redirected_to login_path
  end

  test "ログイン後は未完了の初期設定へ進む" do
    post session_path, params: { email: @user.email, password: "password123!" }
    follow_redirect!
    assert_redirected_to setup_path
  end

  test "初期設定済みならホームを表示する" do
    @organization.update!(setup_completed_at: Time.current)
    post session_path, params: { email: @user.email, password: "password123!" }
    follow_redirect!
    assert_response :success
    assert_includes response.body, "今やること"
  end

  test "別企業の問い合わせ詳細は閲覧できない" do
    @organization.update!(setup_completed_at: Time.current)
    other = Organization.create!(name: "別会社", service_name: "別AI受付", setup_completed_at: Time.current)
    customer = other.customers.create!(name: "別顧客")
    inquiry = other.inquiries.create!(customer:, channel: "phone", category: "相談", summary: "非公開", received_at: Time.current)
    post session_path, params: { email: @user.email, password: "password123!" }

    get inquiry_path(inquiry)
    assert_response :not_found
  end
end
