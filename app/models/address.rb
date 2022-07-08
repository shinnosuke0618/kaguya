class Address < ApplicationRecord
  belongs_to :customer

  validates :post_code, presence: true, length: { maximum: 7, minimun: 7 },numericality: true
  validates :address, presence: true
  validates :name, presence: true




  # orderモデルで使用します。〒OOO-OOO 住所 宛名
  def address_display
  '〒' + post_code + ' ' + address + ' ' + name
  end
end
