module Purchase
  class Manager
    attr_reader :store,
                :result

    def initialize(store)
      @store  = store
      @result = []
    end

    def fulfill(order_set)
      return {} unless order_set.is_a?(Purchase::OrderSet)

      @result = order_set.orders.map do |order|
        store     = @store.to_h
        temp_hash = {
          order_id:          order.order_id,
          fulfilled:         true,
          total_cost:        0.0,
          unfulfilled_items: [],
        }

        order.items.each do |item|
          result = buy_item(store, item.product_id, item.quantity)

          temp_hash[:fulfilled]  = temp_hash[:fulfilled] && result[:unfulfilled].empty?
          temp_hash[:total_cost] += result[:total_cost]
          temp_hash[:unfulfilled_items].concat([*result[:unfulfilled]])
        end

        if order.wrong_items.any?
          temp_hash[:fulfilled]         = false
          temp_hash[:unfulfilled_items] = order.wrong_items.map(&:product_id)
        end

        temp_hash
      end
    end

    protected

    def buy_item(store, product_id, quantity)
      product_data                 = store.fetch(product_id, {})
      price                        = product_data.fetch(:price, 0)
      availability                 = product_data.fetch(:quantity, 0)
      items_to_buy                 = [quantity, availability].min
      items_to_buy                 = 0 if items_to_buy < 0

      store[product_id][:quantity] -= items_to_buy if store.dig(product_id, :quantity)

      result = {
        unfulfilled: [],
        total_cost:  price * items_to_buy
      }

      if availability < quantity or quantity < 0
        result.merge!(unfulfilled: [product_id])
      end

      result
    end
  end
end
