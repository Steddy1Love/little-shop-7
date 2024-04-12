class AddChangeColumnDefaultItem < ActiveRecord::Migration[7.1]
  def change
    change_column :items, :status, :integer, default: 0
  end
end
