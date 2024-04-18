class Item < ApplicationRecord
  enum :status, [:disabled, :enabled], validate: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def top_selling_date
    transactions.where("transactions.result = 1")
    .select("DATE_TRUNC('day', invoices.created_at) AS date, SUM(invoice_items.quantity) AS total_sales")
    .group("date")
    .order("total_sales DESC, date DESC")
    .first
    .date
  end
end
