require "test_helper"

class TenantIsolationTest < ActiveSupport::TestCase
  test "問い合わせは契約企業ごとに分離される" do
    first = Organization.create!(name: "一社", service_name: "AI受付")
    second = Organization.create!(name: "二社", service_name: "AI受付")
    first_customer = first.customers.create!(name: "顧客一")
    second_customer = second.customers.create!(name: "顧客二")
    first.inquiries.create!(customer: first_customer, channel: "phone", category: "相談", summary: "一社の問い合わせ", received_at: Time.current)
    second.inquiries.create!(customer: second_customer, channel: "phone", category: "相談", summary: "二社の問い合わせ", received_at: Time.current)

    assert_equal [ "一社の問い合わせ" ], first.inquiries.pluck(:summary)
    assert_equal [ "二社の問い合わせ" ], second.inquiries.pluck(:summary)
  end
end
