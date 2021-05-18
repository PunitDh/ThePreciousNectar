class CreateWineJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :carts, :listings do |t|
      # t.index [:cart_id, :listing_id]
      # t.index [:listing_id, :cart_id]
    end
  end
end
