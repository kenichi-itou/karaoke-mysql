class Reservation < ApplicationRecord

  belongs_to :user, optional: true

  # 使用料
  KARAOKE_FEE_PER_HOUR = 100 # カラオケルーム: 100円/時間
  BBQ_FEE = 100              # バーベキューコーナー: 100円/回

  # 新規予約は全項目入力必須
  validates :date, :start_time, :end_time, :facility,
            :room_number, :name, :phone,
            :adult_count, :child_count,
            presence: true, on: :create

  validate :no_overlap
  validate :check_people

  def facility_label
    facility == "karaoke" ? "カラオケルーム" : "バーベキューコーナー"
  end

  # 予約時間（時間単位、Float）。時刻未入力や逆転時は0。
  def duration_hours
    return 0 if start_time.blank? || end_time.blank?
    seconds = end_time - start_time
    seconds.positive? ? seconds / 3600.0 : 0
  end

  # 使用料（円）
  def fee
    case facility
    when "karaoke"
      (duration_hours * KARAOKE_FEE_PER_HOUR).round
    when "bbq"
      BBQ_FEE
    else
      0
    end
  end

  def no_overlap
    return unless facility == "karaoke"
    
    overlap = Reservation.where(date: date, facility: facility)
      .where.not(id: id)
      .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlap.exists?
      errors.add(:base, "この時間はすでに予約があります")
    end
  end

  def check_people
    if adult_count.to_i + child_count.to_i <= 0
      errors.add(:base, "人数を入力してください")
    end
  end

end