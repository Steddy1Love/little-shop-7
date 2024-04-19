class ChangeColumnCoupons < ActiveRecord::Migration[7.1]
  def change
    change_column_default :coupons, :status, 0
  end
end
