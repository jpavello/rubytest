describe 'Purchase::Item' do
  context 'Valid Purchase Item' do
    before do
      @item              = Purchase::Item.new(product_id: 1, quantity: 10)
      @item_with_strings = Purchase::Item.new(product_id: '1', quantity: '10')
    end

    it 'Should be valid' do
      expect(@item.valid?).to eq(true)
      expect(@item_with_strings.valid?).to eq(true)
    end

    it 'Expects quantity to be an integer greater than 0' do
      expect(@item.quantity).to eq(10)
      expect(@item_with_strings.quantity).to eq(10)
    end

    it 'Expects product_id to be an integer greater than 1' do
      expect(@item.product_id).to eq(1)
      expect(@item_with_strings.product_id).to eq(1)
    end
  end

  context 'Invalid Purchase Item' do
    before do
      @empty_item = Purchase::Item.new
    end

    it 'Should have errors filled' do
      expect(@empty_item.valid?).to eq(false)
      expect(@empty_item.errors.class).to eq(Array)
      expect(@empty_item.errors.flat_map(&:keys)).to include('product_id_value', 'quantity_value')
    end

    it 'Should have an error if quantity is less than 0' do
      @item = Purchase::Item.new(product_id: 1, quantity: -1)

      expect(@item.valid?).to eq(false)
      expect(@item.errors.flat_map(&:keys)).to include('quantity_value')
    end

    it 'Should have an error if product_id is less than 1' do
      @item = Purchase::Item.new(product_id: 0, quantity: 1)

      expect(@item.valid?).to eq(false)
      expect(@item.errors.flat_map(&:keys)).to include('product_id_value')
    end
  end

end