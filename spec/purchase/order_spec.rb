describe 'Purchase::Order' do

  context 'Valid Purchase Order' do
    before do
      @order = Purchase::Order.new(
        order_id: 1,
        date:     Date.today,
        priority: true
      )
    end

    it 'Should be valid' do
      expect(@order.valid?).to be true
    end
  end

  context 'Invalid Purchase Order' do
    before do
      @attributes = {
        order_id: 1,
        date:     Date.today
      }
      @attributes = @attributes.except(@attributes.keys.sample)

      @order = Purchase::Order.new(**@attributes)
    end

    it 'Should not be valid' do
      expect(@order.valid?).to be(false)
      expect(@order.errors.map(&:first)).not_to include(@attributes.keys)
    end
  end

  context 'Add valid items data' do
    before do
      @instances = 10
      @order     = Purchase::Order.new(
        order_id: 1,
        date:     Date.today,
        priority: true
      )
      @items     = @instances.times.map do |time|
        {
          product_id: time + 1,
          quantity:   rand(1..10)
        }
      end
    end

    it 'Should have all items added to items collection' do
      @order.add_items(@items)

      expect(@order.items.length).to eq(@instances)
      expect(@order.wrong_items.length).to eq(0)
    end
  end

  context 'Add invalid items data' do
    before do
      @instances = 10
      @order     = Purchase::Order.new(
        order_id: 1,
        date:     Date.today,
        priority: true
      )
      @items     = @instances.times.map do |time|
        {
          product_id: time + 1,
          quantity:   -1 * rand(1..10)
        }
      end
    end

    it 'Should have all items added to items collection' do
      @order.add_items(@items)

      expect(@order.wrong_items.length).to eq(@instances)
      expect(@order.items.length).to eq(0)
    end
  end

  context 'Add incomplete items data' do
    before do
      @instances = 10
      @order     = Purchase::Order.new(
        order_id: 1,
        date:     Date.today,
        priority: true
      )
      @items     = @instances.times.map do |time|
        item = {
          product_id: time + 1,
          quantity:   rand(1..10)
        }

        item.except(item.keys.sample)
      end
    end

    it 'Should have all items added to items collection' do
      @order.add_items(@items)

      expect(@order.wrong_items.length).to eq(@instances)
      expect(@order.items.length).to eq(0)
    end
  end

  context 'Add mixed validity items data' do
    before do
      @instances   = 10
      @order       = Purchase::Order.new(
        order_id: 1,
        date:     Date.today,
        priority: true
      )
      @valid_items = @instances.times.map do |time|
        {
          product_id: time + 1,
          quantity:   rand(1..10)
        }
      end
      @wrong_items = @instances.times.map do |time|
        {
          product_id: time + 1,
          quantity:   -1 * rand(1..10)
        }
      end
      @incomplete_items = @instances.times.map do |time|
        attributes = {
          product_id: time + 1,
          quantity:   -1 * rand(1..10)
        }

        attributes.except(attributes.keys.sample)
      end

    end

    it 'Should have all items added to the proper collection' do
      @order.add_items(@valid_items)
      @order.add_items(@wrong_items)
      @order.add_items(@incomplete_items)

      expect(@order.items.length).to eq(@valid_items.length)
      expect(@order.wrong_items.length).to eq(@wrong_items.length + @incomplete_items.length)
    end
  end
end