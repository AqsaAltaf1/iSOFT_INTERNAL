class Payment < ApplicationRecord
  belongs_to :user
  acts_as_tenant :company
  enum :payment_method, %i[bank_transfer cash cheque internationl_wire]

  def self.get_all_payment_methods
    payment_methods.keys.map { |payment_method| [payment_method.humanize, payment_method] }
  end
  
end
