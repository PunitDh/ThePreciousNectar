class PagesController < ApplicationController
	def home
	end

	def about
	end

	def search
		if params[:search].blank?  
			redirect_to(root_path, alert: "Empty field!") and return  
		else  
			@parameter = params[:search].downcase
			# @results = Listing.all.where("lower(name) LIKE :search", search: @parameter)  
			@results = Listing.all.where("lower(name) LIKE :search", search: "%#{@parameter}%")

		end
	end


end