class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_valid_signup_code, only: :create

  # 住民の自己登録に必要な合言葉（登録コード）
  # 本番では必ず環境変数 SIGNUP_CODE で上書きすること
  SIGNUP_CODE = ENV.fetch("SIGNUP_CODE", "utasta-resident").freeze

  private

  # 登録コードが一致しない場合は登録させず、フォームを再表示
  def ensure_valid_signup_code
    submitted = params.dig(:user, :signup_code).to_s.strip
    return if ActiveSupport::SecurityUtils.secure_compare(submitted, SIGNUP_CODE)

    build_resource(sign_up_params)
    resource.validate
    resource.errors.add(:signup_code, "が正しくありません")
    clean_up_passwords(resource)
    set_minimum_password_length
    render :new, status: :unprocessable_entity
  end
end
