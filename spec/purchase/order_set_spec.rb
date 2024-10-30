describe 'Purchase::OrderSet' do
  context 'Valid Purchase Order Set' do
    before do
      orders = [
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
          date:     '2024-10-06',
          priority: false
        },
        {
          order_id: 3,
          items:    [
                      { product_id: 4, quantity: 5 },
                    ],
          date:     '2024-10-03',
          priority: true
        }
      ]

      @order_set = Purchase::OrderSet.new(orders)
    end

    it 'Should have 3 orders' do
      expect(@order_set.orders.size).to eq(3)
    end

    it 'Should have 0 wrong orders' do
      expect(@order_set.wrong_orders.size).to eq(0)
    end

    it 'Should have orders ordered by priority then date' do
      expect(@order_set.orders.map(&:priority)).to eq([0, 0, 1])
      expect(@order_set.orders.map(&:date)).to eq(%w[2024-10-03 2024-10-04 2024-10-06].map { |string| Date.parse(string) })
    end
  end

  context 'Purchase Order Set with invalid items' do
    before do
      orders = [
        {
          order_id: 1,
          items:    [
                      { product_id: 1, quantity: 2 },
                      { product_id: 2, quantity: -5 },
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
          date:     '2024-10-06',
          priority: false
        },
      ]

      @order_set = Purchase::OrderSet.new(orders)
    end

    it 'Should have 2 valid orders' do
      expect(@order_set.orders.size).to eq(2)
    end

    it 'Should have 0 wrong orders' do
      expect(@order_set.wrong_orders.size).to eq(0)
    end

    context 'Purchase Order Set with invalid data' do
      before do
        orders = [
          {
            items:    [
                        { product_id: 1, quantity: 2 },
                        { product_id: 2, quantity: -5 },
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
            priority: false
          },
        ]

        @order_set = Purchase::OrderSet.new(orders)
      end

      it 'Should have 0 valid orders' do
        expect(@order_set.orders.size).to eq(0)
      end

      it 'Should have 2 wrong orders' do
        expect(@order_set.wrong_orders.size).to eq(2)
      end
    end
  end
end
