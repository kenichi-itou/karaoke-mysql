module ReservationsHelper
  # 予約状況の色分けクラス（管理人のみ）
  #   status-new      : 24時間以内に登録された新しい予約（薄い黄色）
  #   status-prepared : 実施登録済み＝鍵投函/席確保（薄いグレー）
  def reservation_status_class(reservation)
    return nil unless user_signed_in? && current_user.admin?

    status = reservation.admin_status
    status ? "status-#{status}" : nil
  end
end
