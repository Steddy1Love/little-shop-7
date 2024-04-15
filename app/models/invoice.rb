class Invoice < ApplicationRecord
  enum :status, ['in progress', 'completed', 'cancelled'], validate: true

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.incomplete_invoices
    joins(:invoice_items)
    .select("invoice_items.* AS invoice_item_id")
    .where.not(status: 2)
    .group("invoice_items.id")
  end

  def clean_date
    self.created_at.strftime("%A, %B %d, %Y")
  end
end
