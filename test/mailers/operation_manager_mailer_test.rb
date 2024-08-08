require 'test_helper'

class OperationManagerMailerTest < ActionMailer::TestCase
  test 'sends finished batch notification email to operator' do
    email = OperationManagerMailer.update_shipping_status_batch_finish

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['operation_manager@example.com'], email.to
    assert_equal 'Order batch shipping has been updated', email.subject
  end
end
