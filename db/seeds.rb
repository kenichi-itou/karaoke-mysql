# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ---- デモ用アカウント（idempotent） ----
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.role = :admin
  u.name = "管理人"
end

resident = User.find_or_create_by!(email: "resident@example.com") do |u|
  u.password = "password"
  u.role = :resident
  u.name = "ヤマダ タロウ"
  u.room_number = "1234"
end

# 既存の持ち主なし予約をデモ住民に割り当てる
Reservation.where(user_id: nil).update_all(user_id: resident.id)

puts "Seeded users: admin=#{admin.email}, resident=#{resident.email}"
