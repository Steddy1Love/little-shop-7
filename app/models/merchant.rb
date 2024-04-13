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


  def pending_items #this returns an object of packaged items on merchants invoice_items
    invoice_items.packaged.map do |invoice_item|
      invoice_item.item
    end
    # Item
    # .joins(items: :invoice_items)
    # .distinct
    # .select(:name)
    # .where(status: "packaged")
  end
end
