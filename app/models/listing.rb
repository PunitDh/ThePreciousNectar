class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :region
  has_one_attached :image
  has_and_belongs_to_many :carts
end