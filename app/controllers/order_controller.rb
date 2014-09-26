class OrderController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = ShopifyAPI::Order.paginate(per: PER_PAGE, page: params[:page], params: {customer_id: current_user.shopify_customer_id})
    if sort = params[:sort]
      @param = params[:sort]
      case sort
      when 'shipped'
        @orders = @orders.select {|order| order.fulfillment_status == 'fulfilled'}
      when 'not shipped'
        @orders = @orders.select {|order| order.fulfillment_status != 'fulfilled'}
      when 'price'
        @orders = @orders.sort_by {|order| order.total_price_usd }
      when 'item count'
        @orders = @orders.sort_by {|order| order.line_items.count }
      when 'date newest'
        @orders = @orders.sort_by {|order| order.created_at }.reverse
      when 'date oldest'
        @orders = @orders.sort_by {|order| order.created_at }
      else
        @param = nil
        @orders
      end
    end
    if @orders.is_a?(Array)
      @orders = Kaminari.paginate_array(@orders).page(1).per(10)
    end
  end
end
