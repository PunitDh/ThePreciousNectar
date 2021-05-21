class Cart < ApplicationRecord
    belongs_to :user
    has_many :listings
    has_many :cart_listings
end