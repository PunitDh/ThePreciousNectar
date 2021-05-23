class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :firstname
      t.string :lastname
      t.belongs_to :user, null: false, foreign_key: true
      t.string :email
      t.integer :bsb
      t.integer :account

      t.timestamps
    end
  end
end
