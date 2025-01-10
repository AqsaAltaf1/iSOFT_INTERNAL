# app/commands/authenticate_user.rb
# frozen_string_literal: true

# authenticating user for correct password and email, to be sent on JSON
class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    unless user.present?
      errors.add :message, 'Invalid email / password'
      return nil
    end
    user
  end
end
