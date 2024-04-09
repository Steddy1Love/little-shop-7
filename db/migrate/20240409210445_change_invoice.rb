class ChangeInvoice < ActiveRecord::Migration[7.1]
  def change
    change_column :invoices, :status, :integer, default: 0
  end
end
