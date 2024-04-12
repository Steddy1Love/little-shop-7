class AddChangeColumnDefaultMerchant < ActiveRecord::Migration[7.1]
  def change
    change_column :merchants, :status, :integer, default: 0
  end
end
