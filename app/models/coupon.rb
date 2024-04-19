class Coupon < ApplicationRecord
  enum :status, ['disabled', 'enabled'], validate: true

  belongs_to :merchant
  has_many :invoices

  validates :code, uniqueness: true
  # validate :check_coupon_limit, on: :create
  # validate :check_coupon_value, on: :update

private

def check_coupon_limit
  errors.add(:base, "Merchant cannot have more than 5 activated coupons") if merchant.coupons.where(active: true).count >= 5
end

def check_coupon_value
  if dollar_off && invoice && invoice.total_cost_for_merchant(merchant) < dollar_off
    invoice.update(total_cost: 0)
  end
end
end
