class RemoveAmountFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :amount, :integer
  end
end
