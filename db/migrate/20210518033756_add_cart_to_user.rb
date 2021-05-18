class AddCartToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :cart, null: false, foreign_key: true
  end
end