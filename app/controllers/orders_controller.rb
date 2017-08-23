class OrdersController < ApplicationController
  def create

    # debugger params沒有卡號

    # 成立訂單

    # debugger

    order = Order.new

    # 下面那個的醜寫法，把購買物品塞到訂單變成 OrderItem
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

    # 訂單建立收件者資訊
    # order.build_recipient(params[:order][:recipient]) #strong params
    order.build_recipient(orders_params[:recipient])
    # order.recipient = Recipient.new(orders_params[:recipient]) 跟上面那行一樣
    order.save

    # @order.order_items =

    # order.order_items.new()
    # 1. params[:order][:recipient][:name]
    # 2. order items <- current_cart.items

    # # 刷卡
    # result = Payment::BraintreeService.new(params[:payment_method_nonce],
    #                                        current_cart.total_price).run
    # payment = BraintreeService.new(params[:payment_method_nonce],
    #                                        current_cart.total_price)
    payment = BraintreeService.new(params[:payment_method_nonce],
                                            current_cart.total_price)
    result = payment.run

    # result = Braintree::Transaction.sale(
    #   :amount => current_cart.total_price,
    #   :payment_method_nonce => params[:payment_method_nonce],
    #   :options => {
    #     :submit_for_settlement => true
    #   }
    # )

    if result.success?
      order.pay!
    end

    # if 刷卡成功
    #   order.pay!
    # end

    # 通知
    # 清空購物車
    session[:cart_9487] = nil

    redirect_to products_path, notice: "感謝付款！"
  end

  private
  def orders_params
    params.require(:order).permit(recipient: [:name, :tel, :address, :email])
  end
end
