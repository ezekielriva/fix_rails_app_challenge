# Mailer that group Operation Manager notifications
class OperationManagerMailer < ApplicationMailer
  OPERATION_MANAGER_EMAIL = ENV['OPERATION_MANAGER_EMAIL'] || 'default@example.com'

  default from: 'notifications@example.com', to: OPERATION_MANAGER_EMAIL

  # Notification when a Order batch has been updated with latest shipping status.
  def update_shipping_status_batch_finish
    mail(subject: 'Order batch shipping has been updated')
  end
end
