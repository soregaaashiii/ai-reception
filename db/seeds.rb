# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
organization = Organization.find_or_create_by!(name: "試作株式会社") do |record|
  record.service_name = "AI受付"
end
organization.locations.find_or_create_by!(name: "本社") { |location| location.primary = true }
organization.users.find_or_create_by!(email: "owner@example.jp") do |user|
  user.name = "試作 オーナー"
  user.role = "owner"
  user.password = "password123!"
end if Rails.env.development?
