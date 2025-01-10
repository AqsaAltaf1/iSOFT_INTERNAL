module PaymentsHelper
  def get_payment_method
    Payment.get_all_payment_methods
  end
end

