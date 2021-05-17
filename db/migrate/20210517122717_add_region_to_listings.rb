class AddRegionToListings < ActiveRecord::Migration[6.1]
  def change
    add_reference :listings, :region, null: false, foreign_key: true
  end
end
