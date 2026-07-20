require "test_helper"

class SetupWizardTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.create!(name: "設定会社", service_name: "AI受付")
    @user = @organization.users.create!(name: "設定担当", email: "setup@example.jp", password: "password123!", role: "owner")
    post session_path, params: { email: @user.email, password: "password123!" }
  end

  test "会社情報を途中保存して次へ進める" do
    patch setup_path, params: { step: 1, organization: { name: "更新会社", service_name: "受付係", industry: "工務店" } }
    assert_redirected_to setup_path(step: 2)
    assert_equal "更新会社", @organization.reload.name
    assert_equal 2, @organization.setup_step
  end

  test "初期設定を完了できる" do
    post complete_setup_path
    assert_redirected_to root_path
    assert @organization.reload.setup_complete?
    assert @organization.reception_enabled?
  end
end
