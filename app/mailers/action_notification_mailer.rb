class ActionNotificationMailer < ApplicationMailer
  default from: "mytestgmailemail@gmail.com"

  def action_notification_email
    @operation = params[:operation]
    mail(to: @operation.user, subject: "Action has been taken")
  end


end