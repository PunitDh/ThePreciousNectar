class Listing < ApplicationRecord
  # validates :name, :price, presence: true
  
  belongs_to :user
  belongs_to :category
  belongs_to :region
  has_one_attached :image

  has_many :cart_listings, dependent: :destroy
  has_many :carts, through: :cart_listings
  # has_many :carts, through: :cart_listings, dependent: :destroy
  # has_and_belongs_to_many :cart_listings, dependent: :destroy
  # has_and_belongs_to_many :transactions # If issues persist, delete this line

  after_create do
    product = Stripe::Product.create(name: name)
    price = Stripe::Price.create(product: product, unit_amount: self.price, currency: 'aud')
    update(stripe_product_id: product.id, stripe_price_id: price.id)
  end

  def to_s  # Just so that listing.name does not have to be typed in every time
    name
  end

end