class PagesController < ApplicationController
	def home	# The home page of the website
	end

	def about	# The website's About page
	end

	def search	# The search functionality
		if params[:query].blank?
			@listings = nil
		else
			# Do a search based on "LIKE" parameters in name and descriptions
			@parameter = params[:query].downcase
			@listings = Listing.all.where("lower(name) LIKE :search OR lower(description) like :search ", search: "%#{@parameter}%")
		end
	end
end