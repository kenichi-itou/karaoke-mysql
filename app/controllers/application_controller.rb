class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :owner_or_admin?

  protected

  # 新規登録・プロフィール更新で氏名・部屋番号も受け付ける
  def configure_permitted_parameters
    extra = %i[name room_number]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra)
    devise_parameter_sanitizer.permit(:account_update, keys: extra)
  end

  private

  # その予約の個人情報を閲覧・操作してよいユーザーか（本人 or 管理人）
  def owner_or_admin?(reservation)
    return false unless user_signed_in?
    current_user.admin? || reservation.user_id == current_user.id
  end
end
