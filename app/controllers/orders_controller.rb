class OrdersController < ApplicationController
  def create

    # debugger params沒有卡號

    # 成立訂單

    # debugger

    order = Order.new

    # items = []
    # current_cart.items.each do |item|
    #   #t.integer "product_id"
    #   #t.integer "quantity"
    #   #t.integer "order_id"
    #   items << OrderItem.new(product: item.product, quantity: item.quantity)
    # end
    # order.order_items = items

    current_cart.items.each do |item|
      order.order_items.build(product: item.product, quantity: item.quantity)
    end

    # order.build_recipient(params[:order][:recipient]) #strong params
    order.build_recipient(orders_params[:recipient])
    # order.recipient = Recipient.new(orders_params[:recipient]) 跟上面那行一樣
    order.save

    # @order.order_items =

    order.order_items.new()
    # 1. params[:order][:recipient][:name]
    # 2. order items <- current_cart.items

    # 刷卡
    # if 刷卡成功
    #   order.pay!
    # end

    # 通知
    # 清空購物車

    redirect_to products_path, notice: "感謝付款！"
  end

  private
  def orders_params
    params.require(:order).permit(recipient: [:name, :tel, :address, :email])
  end
end
