describe 'Stock::Item' do

  context 'Valid Stock Item' do
    before do
      @item              = Stock::Item.new(product_id: 1, quantity: 10, price: 0.01)
      @item_with_strings = Stock::Item.new(product_id: '1', quantity: '10', price: '0.01')
    end

    it 'Should be valid' do
      expect(@item.valid?).to eq(true)
      expect(@item_with_strings.valid?).to eq(true)
    end

    it 'Expects quantity to be an integer greater than 0' do
      expect(@item.quantity).to eq(10)
      expect(@item_with_strings.quantity).to eq(10)
    end

    it 'Expects product_id to be an integer greater than 0' do
      expect(@item.product_id).to eq(1)
      expect(@item_with_strings.product_id).to eq(1)
    end

    it 'Expects price to be a float greater than 0.01' do
      expect(@item.product_id).to eq(1)
      expect(@item_with_strings.price).to eq(0.01)
    end
  end

  context 'Invalid Stock Item' do
    before do
      @empty_item        = Stock::Item.new
      @wrong_values_item = Stock::Item.new(product_id: 0, quantity: -1, price: 0.001)
    end

    it 'Should have errors filled' do
      expect(@empty_item.valid?).to eq(false)
      expect(@empty_item.errors.class).to eq(Array)
      expect(@empty_item.errors.flat_map(&:keys)).to include('product_id_value', 'quantity_value', 'price_value')
    end

    it 'Should have an error if quantity is less than 0' do
      expect(@wrong_values_item.valid?).to eq(false)
      expect(@wrong_values_item.errors.flat_map(&:keys)).to include('quantity_value')
    end

    it 'Should have an error if product_id is less than 1' do
      expect(@wrong_values_item.valid?).to eq(false)
      expect(@wrong_values_item.errors.flat_map(&:keys)).to include('product_id_value')
    end
  end

  context 'Incomplete Stock Item' do
    it 'Should produce an invalid Stock Item' do
      attributes = { product_id: rand(1..100), quantity: rand(1..100), price: rand(0.01..1_000.0) }
      # remove a random key from valid attributes to ensure random invalidity reasons due to missing values
      @item = Stock::Item.new(**attributes.except(attributes.keys.sample))

      expect(@item.valid?).to eq(false)
    end
  end

end