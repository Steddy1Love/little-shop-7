class Invoice < ApplicationRecord
  enum :status, ['in progress', 'completed', 'cancelled'], validate: true

  belongs_to :coupon, optional: true
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.incomplete_invoices
    joins(:invoice_items)
    .distinct
    .where.not(invoice_items: { status: 2 })
    .order(:created_at)
  end

  def formatted_date
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def customer_name
    "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_for_merchant(merchant)
    items.where(merchant: merchant)
    .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def grand_total_calc(merchant, coupon)
    if coupon.percent_or_dollar == 'percent'
      x = (self.total_revenue_for_merchant(merchant) - (self.total_revenue_for_merchant(merchant) * (coupon.amount_off.to_f / 100.00))) / 100
    else
      [(self.total_revenue_for_merchant(merchant) - coupon.amount_off), 0].max
    end
  end
end
