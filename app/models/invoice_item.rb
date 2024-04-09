class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  # .transaction is a built in AR method and cant use as an association
  # has_one :transaction, through: :invoice
  has_one :customer, through: :invoice
end
