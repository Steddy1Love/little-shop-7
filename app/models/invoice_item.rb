class InvoiceItem < ApplicationRecord
  enum :status, [:pending, :packaged, :shipped], validate: true

  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  has_one :customer, through: :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true

  def self.items_not_shipped
    Item
    .joins(:invoice_items)
    .distinct
    .select(:name)
    .where(status: "pending")
  end
end
