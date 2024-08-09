class Order < ApplicationRecord
  belongs_to :product

  enum status: [:processing].concat(Fedex::Shipment::STATUS)

  scope :filter_by_customer_name, ->(n) { where('customer_name LIKE ?', "%#{n}%") }
  scope :filter_by_product_id, ->(i) { where(product_id: i) }
  scope :filter_by_status, ->(s) { where(status: s) }

  scope :in_progress, -> { where(status: %i[awaiting_pickup in_transit out_for_delivery]) }

  attribute :status, :integer, default: :processing

  validates_presence_of :status, :customer_name
end
