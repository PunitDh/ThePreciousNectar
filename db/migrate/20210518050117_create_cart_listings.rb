class CreateCartListings < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_listings do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
