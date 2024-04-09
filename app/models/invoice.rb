class Invoice < ApplicationRecord
  enum :status, [:cancelled, :in_progress, :completed], validate: true

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
end