class Profile < ApplicationRecord
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :bsb, presence: true
  validates :account, presence: true
  
  belongs_to :user
  has_one_attached :image
end