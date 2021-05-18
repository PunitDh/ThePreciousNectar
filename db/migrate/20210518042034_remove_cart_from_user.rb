class RemoveCartFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :cart, null: false, foreign_key: true
  end
end