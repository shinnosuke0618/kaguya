class Public::OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def create
    cart_items = current_customer.cart_items.all
    @order = current_customer.orders.new(order_params)
    @order.postage = 800
    if @order.save
      cart_items.each do |cart_item|
        # order_detailsにも一緒にデータを保存する
        order_detail = OrderDetail.new
        order_detail.item_id = cart_item.item_id
        order_detail.order_id = @order.id
        order_detail.quantity = cart_item.quantity
        # 購入が完了したらカート情報を削除するため、ここに保存
        order_detail.price = cart_item.item.price
        # itemとの紐付けが切れる前に保存
        order_detail.save
      end
      redirect_to thanks_orders_path
      # 購入したデータをすべて削除(カートを空にする)
      cart_items.destroy_all

    else
      @order = Order.new(order_params)
      render :new
    end
  end

  def confirm
    @order = Order.new(order_params)
    # 届け先ラジオボタンの判定条件
    # 自身の住所の場合
    if params[:order][:address_number] == "1"

      @order.name = current_customer.last_name
      @order.address = current_customer.address
      @order.post_code = current_customer.post_code

    #登録済みの住所の場合
    elsif params[:order][:address_number] == "2"

      @order.name = Address.find(params[:order][:address_id]).name
      @order.address = Address.find(params[:order][:address_id]).address
      @order.post_code = Address.find(params[:order][:address_id]).post_code

    # 新規登録の住所の場合
    elsif params[:order][:address_number] == "3"

      address_new = current_customer.addresses.new(address_params)
      if address_new.save
      else
        render :new
      end
    end
    @cart_items = current_customer.cart_items.all
    @total_price = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
  end

  def thanks
  end

  def index
    @orders = current_customer.orders.all

  end

  def show
    @order = current_customer.orders.find(params[:id])
    # @total_price = @order.order_details.item.inject(0) { |sum, item| sum + item.order_subtotal }
  end

  private


  def order_params
    params.require(:order).permit(:payment_method, :total_price, :postage, :name, :address, :post_code, :status)
  end

  def address_params
    params.require(:order).permit(:name, :address, :post_code)
  end

end
