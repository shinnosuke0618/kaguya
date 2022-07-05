class Admin::OrderDetailsController < ApplicationController
  def update
    #@order = Order.find(params[:id])
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(order_detail_params)
    @order = Order.find_by(id: @order_detail.order_id)
    @order_details = @order.order_details.all
      if @order_details.where(production_status: 2).any? #もしも一つでも存在したら？
      @order.update(status: 2)
      redirect_to admin_order_path(@order)
    #binding.pry
      elsif @order_details.where(production_status: 3).all?#もしも全部だったら？
      @order.update(status: 3)
      redirect_to admin_order_path(@order)
      else
      redirect_to admin_order_path(@order)
      end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:production_status)
  end
end
