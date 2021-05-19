class ListingPolicy < ApplicationPolicy
    def update?
        user == record.user
    #   user.admin? or not record.published?
    end
end