module Purchase
  class Item
    attr_accessor :errors
    attr_reader :product_id,
                :quantity

    def initialize(product_id: nil, quantity: nil)
      @product_id = product_id.to_i
      @quantity   = quantity.to_i
      @errors     = []
    end

    def valid?
      Validator::Integer.validate(self, 'product_id', (1..))
      Validator::Integer.validate(self, 'quantity', (1..))

      @errors.empty?
    end

    def to_h
      {
        @product_id => @quantity,
      }
    end
  end
end
