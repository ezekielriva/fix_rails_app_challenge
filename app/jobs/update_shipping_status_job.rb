# Makes sure every order has an updated shipping status
# assumption "delivered" is an end state and it shouldn't be updated.
# Using a another job to process the batch itselef
class UpdateShippingStatusJob < ActiveJob::Base
  queue_as :default

  def perform
    Order.in_progress.find_in_batches { |o| UpdateShippingStatusBatchJob.perform_later(o) }
  end
end
