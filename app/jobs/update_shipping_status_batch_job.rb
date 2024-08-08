# Makes sure every order has an updated shipping status
class UpdateShippingStatusBatchJob < ApplicationJob
  queue_as :orders

  def perform(orders)
    updated_orders = orders.map { |o| [o.id, { status: fetch_order_status(o) }] }.to_h

    Order.update(updated_orders.keys, updated_orders.values)

    OperationManagerMailer.update_shipping_status_batch_finish.deliver_now
  end

  def fetch_order_status(order)
    shipment = Fedex::Shipment.find(order.fedex_id)
    shipment.status
  rescue Fedex::ShipmentNotFound => e
    logger.error("update_order: #{order.id}: #{e.message}")
    order.status
  end
end
