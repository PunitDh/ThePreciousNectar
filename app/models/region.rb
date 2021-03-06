class Region < ApplicationRecord
    has_many :listings, dependent: :destroy

    def to_s  # Just so that region.name does not have to be typed in every time
        name
    end
end