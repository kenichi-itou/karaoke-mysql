class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :nullify

  # 住民(resident) / 管理人(admin)
  enum role: { resident: 0, admin: 1 }

  # 新規登録時の合言葉（DBには保存しない仮想属性）
  attr_accessor :signup_code
end
