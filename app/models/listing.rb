class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :variety
  belongs_to :region
  has_one_attached :image
end