class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name_kana, presence: true
  validates :last_name_kana, presence: true
  validates :post_code, presence: true, length: {maximum: 7, minimum: 7}, numericality: true #numericality:属性に数値のみが使えるバリデーション
  validates :address, presence: true
  validates :phone_number, presence: true, length: {maximum: 11, minimum: 10}, numericality: true

  # orderモデルで使用します。〒OOO-OOO 住所 宛名
  def address_display
    '〒' + post_code + ' ' + address + ' ' + last_name + first_name
  end

end
