class CreateCouponInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_invoices do |t|
      t.references :coupon, null: false, foreign_key: true
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
