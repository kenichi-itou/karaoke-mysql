class UsageReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  # GET /usage_reports
  # 月ごとの明細（使用日時別）／設備別・部屋別内訳／全期間の総合計
  def index
    reservations = Reservation.where.not(date: nil).order(:date, :start_time).to_a

    # 月(YYYY-MM) => [予約...]（新しい月から順に）
    @months = reservations
      .group_by { |r| r.date.strftime("%Y-%m") }
      .sort.reverse.to_h

    # 全期間の総合計・設備別
    @grand_total = reservations.sum(&:fee)
    @grand_by_facility = Hash.new(0)
    reservations.each { |r| @grand_by_facility[r.facility] += r.fee }
  end

  private

  def require_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to reservations_path, alert: "この画面は管理人のみ閲覧できます。"
    end
  end
end
