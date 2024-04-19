class Coupon < ApplicationRecord
  belongs_to :merchant
  have_many :invoices, through: :coupon_invoices
end