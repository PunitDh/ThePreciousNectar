class AddQuantityToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :quantity, :integer
  end
end
