require 'test_helper'

class UpdateShippingStatusJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  setup do
    @sample_order = orders(:one)
    @delivered_order = orders(:delivered)
    @in_progress_order = orders(:in_progress)
    @shipping = MiniTest::Mock.new
  end

  test 'updates order shipping status to the latest delivered by Fedex' do
    @shipping.expect(:status, Order.statuses[:delivered])

    Fedex::Shipment.stub(:find, @shipping) do
      perform_enqueued_jobs { UpdateShippingStatusJob.perform_later }
    end

    assert @in_progress_order.reload.status, Order.statuses[:delivered]
    assert @shipping.verify, true
  end

  test 'send a mail when a batch finish' do
    @shipping.expect(:status, Order.statuses[:delivered])

    Fedex::Shipment.stub(:find, @shipping) do
      assert_emails 1 do
        perform_enqueued_jobs { UpdateShippingStatusJob.perform_later }
      end
    end
  end

  test 'doesnt update the record if an error happens' do
    in_progress2 = orders(:in_progress)
    status = in_progress2.status

    stub_find = lambda do |fedex_id|
      raise Fedex::ShipmentNotFound if fedex_id == in_progress2.fedex_id

      @shipping.expect(:status, Order.statuses[:delivered])
      @shipping
    end

    Fedex::Shipment.stub(:find, stub_find) do
      perform_enqueued_jobs { UpdateShippingStatusJob.perform_later }
    end

    assert status, in_progress2.reload.status
    assert @shipping.verify, true
  end
end
