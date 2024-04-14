class Merchant < ApplicationRecord
  enum :status, [:disabled, :enabled], validate: true

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def top_five_customers
    customers.joins(:transactions).where("result = 1").select("customers.*, COUNT(DISTINCT transactions.id) AS transaction_count").order("transaction_count DESC").group(:id).limit(5)
  end


  def packaged_items 
    items.joins(:invoice_items).where("invoice_items.status = 1").select("items.*, invoice_items.invoice_id, invoice_items.created_at")
  end

  def self.top_5_merchants_by_revenue
    joins(:invoice_items, :transactions)
    .where("transactions.result = 1")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
    .distinct
    .group(:id)
    .order(total_revenue: :desc)
    .limit(5)
    # joins(:invoice_items).group(:id).select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue").order("total_revenue DESC")
  end
end