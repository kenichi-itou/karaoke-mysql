class UsageReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  # GET /usage_reports
  # 月ごと・部屋ごとの使用料（月合計）
  def index
    reservations = Reservation.order(date: :desc)

    # { "2026-07" => { "1234" => 合計, "2222" => 合計 }, ... }
    @report = Hash.new { |hash, key| hash[key] = Hash.new(0) }
    reservations.each do |r|
      next if r.date.blank?
      month = r.date.strftime("%Y-%m")
      room = r.room_number.presence || "(未設定)"
      @report[month][room] += r.fee
    end
  end

  private

  def require_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to reservations_path, alert: "この画面は管理人のみ閲覧できます。"
    end
  end
end
