class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[ show edit update destroy prepare unprepare ]
  before_action :require_owner_or_admin!, only: %i[ edit update destroy ]
  before_action :require_admin!, only: %i[ prepare unprepare ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.order(:date, :start_time)

    # カレンダーで日付が選択されたら、その日の予約状況を表示
    if params[:date].present?
      @selected_date = Date.parse(params[:date]) rescue nil
      @day_reservations = Reservation.where(date: @selected_date).order(:start_time) if @selected_date
    end
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    # ログインユーザーのプロフィールから氏名・部屋番号を自動補完
    @reservation = Reservation.new(
      name: current_user.name,
      room_number: current_user.room_number
    )
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = current_user.reservations.build(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: "予約を受け付けました。" }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: "予約を更新しました。", status: :see_other }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy!

    respond_to do |format|
      format.html { redirect_to reservations_path, notice: "予約を削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /reservations/1/prepare  実施登録（鍵投函/席確保）
  def prepare
    @reservation.update_column(:prepared_at, Time.current)
    redirect_back fallback_location: reservations_path,
                  notice: "実施登録しました（#{@reservation.prepared_label}）。"
  end

  # PATCH /reservations/1/unprepare  実施登録の取り消し
  def unprepare
    @reservation.update_column(:prepared_at, nil)
    redirect_back fallback_location: reservations_path,
                  notice: "実施登録を取り消しました。"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # 管理人のみ許可
    def require_admin!
      unless user_signed_in? && current_user.admin?
        redirect_to reservations_path, alert: "この操作は管理人のみ可能です。"
      end
    end

    # 先約を勝手に編集・削除できないようにする（本人か管理人のみ許可）
    def require_owner_or_admin!
      unless owner_or_admin?(@reservation)
        redirect_to reservations_path, alert: "他の住民の予約は編集・削除できません。"
      end
    end

  def reservation_params
    params.require(:reservation).permit(
      :date,
      :start_time,
      :end_time,
      :name,
      :room_number,
      :phone,
      :facility,
      :adult_count,
      :child_count
    )
  end
end
