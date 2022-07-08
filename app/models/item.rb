class Item < ApplicationRecord

  has_many :cart_items
  has_many :order_details

  belongs_to :genre

  has_one_attached :image

  validates :is_active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :introduction, presence: true
  validates :genre_id, presence: true
  validates :price, presence: true


  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end

  def add_tax_price
    (self.price * 1.1).round
  end

end
