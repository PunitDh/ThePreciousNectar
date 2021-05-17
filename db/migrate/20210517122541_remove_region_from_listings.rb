class RemoveRegionFromListings < ActiveRecord::Migration[6.1]
  def change
    remove_column :listings, :region, :integer
  end
end
