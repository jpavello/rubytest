module Stock
  class Storage
    attr_reader :items, :wrong_items

    def initialize
      @items       = []
      @wrong_items = []
    end

    def restock(items: [])
      [*items].compact.each do |item|
        item = Stock::Item.new(**item)

        if item.valid?
          @items
        else
          @wrong_items
        end.push(item)

      end
    end

    def to_h
      @items.group_by(&:product_id)
            .inject({}) do |hash, (product_id, collection)|
        hash.merge(product_id => {
          quantity: collection.sum(&:quantity),
          price:    collection.map(&:price).min
        })
      end
    end
  end
end
