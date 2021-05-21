class Category < ApplicationRecord
    has_many :listings

    def to_s  # Just so that listing.name does not have to be typed in every time
        name
    end    
end
