module Stock
  class Item
    attr_accessor :errors
    attr_reader :product_id,
                :price,
                :quantity

    def initialize(product_id: nil, quantity: nil, price: nil)
      @errors     = []
      @product_id = product_id.to_i
      @quantity   = quantity.to_i
      @price      = price.to_f
    end

    def valid?
      Validator::Integer.validate(self, 'product_id', (1..))
      Validator::Numeric.validate(self, 'price', (0.01..))
      Validator::Integer.validate(self, 'quantity', (1..))

      @errors.empty?
    end

    def to_hash
      {
        product_id: product_id,
        quantity:   quantity,
        price:      price
      }
    end
  end
end
