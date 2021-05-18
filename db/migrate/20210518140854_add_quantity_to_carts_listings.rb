class AddQuantityToCartsListings < ActiveRecord::Migration[6.1]
  def change
    add_column :carts_listings, :quantity, :integer
  end
end