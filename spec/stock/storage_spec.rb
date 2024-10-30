describe 'Stock::Item' do

  context 'Valid Stock Item' do
    before do
      @storage = Stock::Storage.new
    end

    it 'Should have an accessible items collection' do
      expect(@storage.items.class).to eq(Array)
    end

    it 'Should have an accessible wrong_items collection' do
      expect(@storage.wrong_items.class).to eq(Array)
    end
  end

  context 'Adding a single valid Stock Item' do
    before do
      @storage = Stock::Storage.new
      @item    = Stock::Item.new(product_id: 1, quantity: 10, price: 1.02)
    end

    it 'Should have a valid Stock Item inside items collection' do
      @storage.restock(items: @item)

      expect(@storage.items.length).to eq(1)
    end
  end

  context 'Adding a valid Stock Item collection' do
    before do
      @instances = 100
      @storage   = Stock::Storage.new
      @items     = @instances.times.map do |time|
        Stock::Item.new(
          product_id: time + 1, # avoid product_id to be zero
          quantity:   rand(1..10),
          price:      rand(0.01..100.0).round(2)
        )
      end
    end

    it 'Should have all Stock Items added into items collection' do
      @storage.restock(items: @items)

      expect(@storage.items.length).to eq(@instances)
      expect(@storage.wrong_items.length).to eq(0)
    end
  end

  context 'Adding a single invalid Stock Item' do
    before do
      @storage = Stock::Storage.new
      @item    = Stock::Item.new(product_id: 1, quantity: -1, price: 1.02)
    end

    it 'Should have the Stock Item added into wrong_items collection' do
      @storage.restock(items: @item)

      expect(@storage.wrong_items.length).to eq(1)
      expect(@storage.items.length).to eq(0)
    end
  end

  context 'Adding an invalid Stock Item collection' do
    before do
      @instances = 10
      @storage   = Stock::Storage.new
      @items     = @instances.times.map do |time|
        Stock::Item.new(
          product_id: time + 1, # avoid product_id to be zero
          quantity:   rand(1..10) * -1, # ensure wrong quantity
          price:      rand(0.01..100.0).round(2)
        )
      end
    end

    it 'Should have all Stock Items added into wrong_items collection' do
      @storage.restock(items: @items)

      expect(@storage.wrong_items.length).to eq(@instances)
      expect(@storage.items.length).to eq(0)
    end
  end

end
