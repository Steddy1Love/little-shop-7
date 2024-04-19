class RemoveColumnCouponsFromInvoices < ActiveRecord::Migration[7.1]
  def change
    remove_column(:invoices, :coupon_id)
  end
end
