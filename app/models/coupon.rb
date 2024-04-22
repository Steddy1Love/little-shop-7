class Coupon < ApplicationRecord
  enum :status, ['inactive', 'active'], validate: true
  enum :percent_or_dollar, ['percent', 'dollar'], validate: true

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices
  
  validate :check_coupon_limit, on: :create
  validate :check_unique_code, on: :create
  # validate :check_coupon_value, on: :update



  def check_coupon_limit
    if merchant.coupons.where(status: 1).count >= 5
      errors.add(:base, "Merchant cannot have more than 5 active coupons")
    end
  end

  def check_unique_code
    if Coupon.exists?(code: code)
      errors.add(:base, "Code is not unique")
    end
  end

  def number_purchases
    self.transactions.where("result = 1").count
  end

  def cannot_deactivate
    self.invoices.where(status: 0)
    self.id
  end
  # def check_coupon_value
  #   if dollar_off && invoice && invoice.total_cost_for_merchant(merchant) < dollar_off
  #     invoice.update(total_cost: 0)
  #   end
  # end
end
