class Reservation < ApplicationRecord

  validate :no_overlap
  validate :check_people

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