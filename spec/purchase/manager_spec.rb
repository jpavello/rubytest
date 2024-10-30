describe 'Purchase::Manager' do

  context 'Fulfill an Order Set' do
    before do
      storage = Stock::Storage.new
      storage.restock(items: [
                               { product_id: 1, quantity: 5, price: 10.0 },
                               { product_id: 2, quantity: 3, price: 15.0 },
                               { product_id: 3, quantity: 2, price: 20.0 }
                             ])

      manager   = Purchase::Manager.new(storage)
      order_set = Purchase::OrderSet.new(
        [
          {
            order_id: 1,
            items:    [
                        { product_id: 1, quantity: 2 },
                        { product_id: 2, quantity: 5 },
                        { product_id: 3, quantity: 1 }
                      ],
            date:     '2024-10-04',
            priority: true
          },
          {
            order_id: 2,
            items:    [
                        { product_id: 2, quantity: 3 },
                      ],
            date:     '2024-10-04',
            priority: false
          },
        ]
      )

      manager.fulfill(order_set)

      @order_1_outcome = manager.result.select { |order| order[:order_id].eql?(1) }.first
      @order_2_outcome = manager.result.select { |order| order[:order_id].eql?(2) }.first
    end

    it 'Should not complete order_id #1' do
      expect(@order_1_outcome[:fulfilled]).to eq(false)
    end

    it 'Should calculate total_cost for order_id #1' do
      expect(@order_1_outcome[:total_cost]).to eq(85.0)
    end

    it 'Should not fulfill order_id #1 product_id #2 request' do
      expect(@order_1_outcome[:unfulfilled_items].length).to eq(1)
      expect(@order_1_outcome[:unfulfilled_items]).to include(2)
    end

    it 'Should fulfill order_id #2' do
      expect(@order_2_outcome[:fulfilled]).to be(true)
      expect(@order_2_outcome[:total_cost]).to be(45.0)
      expect(@order_2_outcome[:unfulfilled_items].length).to eq(0)
    end

  end

  context 'Fulfill an Order Set with wrong data' do
    before do
      storage = Stock::Storage.new
      storage.restock(items: [
                               { product_id: 1, quantity: 5, price: 10.0 },
                               { product_id: 2, quantity: 3, price: 15.0 },
                               { product_id: 3, quantity: 2, price: 20.0 }
                             ])

      manager   = Purchase::Manager.new(storage)
      order_set = Purchase::OrderSet.new(
        [
          {
            order_id: 1,
            items:    [
                        { product_id: 1, quantity: -2 },
                        { product_id: 2 },
                        {}
                      ],
            date:     '2024-10-04',
            priority: true
          },
        ]
      )

      manager.fulfill(order_set)

      @order_1_outcome = manager.result.select { |order| order[:order_id].eql?(1) }.first
      @order_2_outcome = manager.result.select { |order| order[:order_id].eql?(2) }.first
    end

    it 'Should not complete order_id #1' do
      expect(@order_1_outcome[:fulfilled]).to be(false)
    end

    it 'Should calculate total_cost for order_id #1 as 0' do
      expect(@order_1_outcome[:total_cost]).to eq(0.0)
    end

    it 'Should include as unfulfilled order_id #1 faulty products' do
      expect(@order_1_outcome[:unfulfilled_items].length).to eq(3)
      expect(@order_1_outcome[:unfulfilled_items]).to include(0, 1, 2)
    end
  end

end
