class RemoveColumnFromCartsListings < ActiveRecord::Migration[6.1]
  def change
    remove_column :carts_listings, :quantity, :integer
  end
end
