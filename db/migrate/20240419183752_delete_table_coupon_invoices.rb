class DeleteTableCouponInvoices < ActiveRecord::Migration[7.1]
  def change
    drop_table :coupon_invoices
  end
end
