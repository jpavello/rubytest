Dir['./lib/**/*.rb'].each { |file| require file }

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
    date:     '2024-10-04',
    priority: false
  },
  {
    order_id: 3,
    items:    [
                { product_id: 10, quantity: 3 },
              ],
    date:     '2024-10-06',
    priority: false
  },
  {
    order_id: 4,
    items:    [
                { product_id: 1, quantity: 3 },
              ],
    date:     '2024-10-06',
    priority: false
  },
  {
    order_id: 5,
    items:    [
                { product_id: 1, quantity: 3 },
              ],
    date:     '2024-10-05',
    priority: false
  },
  {
    order_id: 6,
    items:    [
                { product_id: 1, quantity: 3 },
                { product_id: 3, quantity: 1 }
              ],
    date:     '2024-10-06',
    priority: true
  }
]

stock = [
  { product_id: 1, quantity: 5, price: 10.0 },
  { product_id: 2, quantity: 3, price: 15.0 },
  { product_id: 3, quantity: 2, price: 20.0 }
]

storage = Stock::Storage.new
storage.restock(items: stock)

order_set = Purchase::OrderSet.new(orders)

pp Purchase::Manager.new(storage).fulfill(order_set)
