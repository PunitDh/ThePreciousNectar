class Profile < ApplicationRecord
  validates :firstname, :lastname, presence: true
  belongs_to :user
  has_one_attached :image
end