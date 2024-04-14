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


  def packaged_items #returns array of items with status = packaged
    self.items
    .select("items.name, invoice_items.invoice_id, invoices.created_at, invoice_items.status")
    .joins(invoices: :invoice_items)
    .where("invoice_items.status = 1")
    .order("invoices.created_at")
    .distinct
    # returns items in an array
  end
end

# select items.name, invoice_items.invoice_id, invoices.created_at, invoice_items.status
# from items
# join invoice_items
# on items.id = invoice_items.item_id
# join invoices
# on invoices.id = invoice_items.invoice_id
# where invoice_items.status = 1
# order by invoices.created_at;

#Item.select('items.*, invoice_items.*').joins(:invoice_items).where(status: "pending") -> empty array

# joins(:merchant, :invoice_items).pluck('items.name', 'invoice_items.id')

# Item.joins(merchant: { items: { invoices: :invoice_items } }).pluck('items.name', 'invoice_items.id')