class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.integer :price
      t.integer :vintage
      t.integer :category#, null: false, foreign_key: true
      t.integer :region#, null: false, foreign_key: true
      t.timestamps
    end
  end
end