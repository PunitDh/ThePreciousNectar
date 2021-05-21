class AddMessageToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :message, :text
  end
end
