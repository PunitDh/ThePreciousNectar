class Cart < ApplicationRecord
    belongs_to :user
    # has_many :listings, through: :cart_listings
    has_many :cart_listings, dependent: :destroy
    has_many :listings, through: :cart_listings
end