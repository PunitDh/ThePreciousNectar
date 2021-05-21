class Cart < ApplicationRecord
    belongs_to :user
    has_many :listings, dependent: :destroy
    has_many :cart_listings, dependent: :destroy
end