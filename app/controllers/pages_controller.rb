class PagesController < ApplicationController
	def home
	end

	def about
	end

	def search
		if params[:search].blank?
			@results = nil
		else  
			@parameter = params[:search].downcase
			@results = Listing.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")
		end
	end
end