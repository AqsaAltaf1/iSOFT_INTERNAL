class SendUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    user = User.find(user.id)
    receivers = User.where(user_type: :admin, company: user.company) + [user] + User.all_hrs
    receivers.each do |receiver|
      subject = receiver.email == user.email ? "Create your account by Signup" : "New User Created: #{user.email}"
      UserMailer.with(user: user, receiver: receiver, subject: subject).user_create.deliver_now
    end
  end
end
