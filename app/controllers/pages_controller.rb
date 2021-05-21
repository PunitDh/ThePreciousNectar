class PagesController < ApplicationController
	def home
	end

	def about
	end

	def search
		if params[:query].blank?
			@listings = nil
		else  
			@parameter = params[:query].downcase
			@listings = Listing.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")
		end
	end
end