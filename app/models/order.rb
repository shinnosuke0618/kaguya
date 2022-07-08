class Order < ApplicationRecord

  has_many :order_details

  belongs_to :customer

  enum payment_method: { credit_card: 0, transfer: 1 }
  enum status: { waiting_payment: 0, confirm_payment: 1, production: 2, send_ready: 3, send_complete: 4 }



  def add_tax_price
    (self.price * 1.1).round
  end

    # 小計を求めるメソッド
  def subtotal
    item.add_tax_price * quantity
  end

end
