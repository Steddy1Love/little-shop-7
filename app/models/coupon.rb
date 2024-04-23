class Coupon < ApplicationRecord
  enum :status, ['inactive', 'active'], validate: true
  enum :percent_or_dollar, ['percent', 'dollar'], validate: true

  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices
  
  validate :check_coupon_limit, on: :create
  validate :check_unique_code, on: :create

  def check_coupon_limit
    return unless merchant # For whatever reason this validation is being run even when a coupon is not being created.

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
    if self.invoices.where(status: 0) != []
      self.id
    else
      false
    end
  end
end
