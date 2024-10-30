require 'date'

module Purchase
  class Order
    attr_accessor :errors
    attr_reader :order_id,
                :date,
                :priority,
                :items,
                :wrong_items

    def initialize(order_id: nil, date: nil, priority: nil, items: [])
      @date        = Date.parse(date.to_s) rescue nil
      @order_id    = order_id.to_i
      @priority    = priority.to_s.eql?('true') ? 0 : 1
      @items       = []
      @wrong_items = []
      @errors      = []

      add_items(items)

      valid?
    end

    def add_items(items = [])
      [*items].each do |item|
        item = Purchase::Item.new(**item)

        if item.valid?
          @items
        else
          @wrong_items
        end.push(item)

      end
    end

    def valid?
      Validator::Integer.validate(self, 'order_id', (1..))
      Validator::Integer.validate(self, 'priority', (0..1))
      Validator::Date.validate(self, 'date')

      @errors.empty?
    end

    def to_h
      {
        order_id: @order_id,
        items: {}
      }
    end
  end
end
