class Coupon < ApplicationRecord
  enum :status, ['disabled', 'enabled'], validate: true
  enum :percent_or_dollar, ['percent', 'dollar'], validate: true

  belongs_to :merchant
  has_many :invoices

  
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

  # def check_coupon_value
  #   if dollar_off && invoice && invoice.total_cost_for_merchant(merchant) < dollar_off
  #     invoice.update(total_cost: 0)
  #   end
  # end
end
