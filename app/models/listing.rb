class Listing < ApplicationRecord
  validates :name, :price, presence: true
  
  belongs_to :user
  belongs_to :category
  belongs_to :region
  has_one_attached :image
  has_and_belongs_to_many :carts
  has_and_belongs_to_many :orders

  def to_s  # Just so that listing.name does not have to be typed in every time
    name
  end

end