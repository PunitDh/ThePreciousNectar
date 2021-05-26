class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  before_create :create_cart 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :github, :google_oauth2]

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # Associate customer with Stripe customer ID
  after_create do
    customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: customer.id)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0,20]
                         )
    end
    user
  end

  def firstname
    self.profile.firstname
  end

  def lastname
    self.profile.lastname
  end

  # def to_s  # Just so that listing.name does not have to be typed in every time
  #   self.profile.name
  # end

  has_one :cart, dependent: :destroy
  has_many :listings, dependent: :destroy
  
  has_many :sales, class_name: "Transaction", foreign_key: :seller_id
  has_many :sold_wines, through: :sales, source: :listing, dependent: :destroy

  has_many :purchases, class_name: "Transaction", foreign_key: :buyer_id
  has_many :purchased_wines, through: :purchases, source: :listing, dependent: :destroy

  has_many :conversations, dependent: :destroy

  # To see all buyers or see all sellers
  scope :sellers, -> { joins(:sales) }
  scope :buyers, -> { joins(:purchases) }

  has_one :profile, dependent: :destroy

  private
    def create_cart
      self.build_cart
    end
end