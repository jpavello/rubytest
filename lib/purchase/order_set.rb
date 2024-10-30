module Purchase
  class OrderSet
    attr_accessor :errors
    attr_reader :orders,
                :wrong_orders

    def initialize(orders = [])
      @wrong_orders = []
      @orders       = []

      add(orders)

      sort
    end

    def add(orders = [])
      [*orders].compact.map do |order|
        order = Purchase::Order.new(**order)

        if order.valid?
          @orders
        else
          @wrong_orders
        end.push(order)
      end

      sort
    end

    def to_h
      @orders.group_by(&:order_id).inject({}) do |h, (id, collection)|
        h.merge(id => collection.flat_map(&:items).inject({}) do |h1, collection|
          h1.merge(collection.product_id => collection.quantity)
        end)
      end
    end

    protected

    def sort
      @orders.sort_by! do |order|
        [order.priority, order.date]
      end
    end
  end
end