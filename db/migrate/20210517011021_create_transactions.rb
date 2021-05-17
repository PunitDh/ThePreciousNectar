class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :seller, null: false#, foreign_key: true
      t.references :buyer, null: false#, foreign_key: true
      t.references :listing, null: false#, foreign_key: true
      t.integer :amount, default: 0
      t.timestamps
    end
  end
end