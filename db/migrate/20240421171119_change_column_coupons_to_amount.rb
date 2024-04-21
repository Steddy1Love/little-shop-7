class ChangeColumnCouponsToAmount < ActiveRecord::Migration[7.1]
  def change
    remove_column :coupons, :percent_off
    remove_column :coupons, :dollar_off
    add_column :coupons, :amount_off, :integer
    add_column :coupons, :percent_or_dollar, :integer
  end
end
