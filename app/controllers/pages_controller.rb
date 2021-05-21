class PagesController < ApplicationController
	def home	# The Homepage of the website
	end

	def about	# The website's About page
	end

	def search	# The search functionality
		if params[:query].blank?
			@listings = nil
		else
			# Do a search based on "LIKE" parameters
			@parameter = params[:query].downcase
			@listings = Listing.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")
		end
	end
end