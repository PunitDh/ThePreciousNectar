class AddColumnToCartListing < ActiveRecord::Migration[6.1]
  def change
    add_column :cart_listings, :quantity, :integer
  end
end