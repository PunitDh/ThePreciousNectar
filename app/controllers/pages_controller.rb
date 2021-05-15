class PagesController < ApplicationController

	before_action :authenticate_user!, only: [:sell] 

	def home
	end

	def about
	end

	def sell
	end

	def buy
	end
end