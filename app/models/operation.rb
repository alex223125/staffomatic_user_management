class Operation < ApplicationRecord

  after_commit :notify, on: :create

  def notify
    ActionNotificationMailer.with({operation: self})
                            .action_notification_email
                            .deliver_now
  end

end
