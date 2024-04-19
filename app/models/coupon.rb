class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, through: :coupon_invoices
end