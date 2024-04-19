class AddColumnCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :status, :integer
  end
end
