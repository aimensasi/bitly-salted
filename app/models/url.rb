require 'open-uri'
require 'nokogiri'
class Url < ActiveRecord::Base

	# This is Sinatra! Remember to create a migration!
	REGEX_URL = /^(https|http):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
	
	# before_create do 

	# 	self.short_form = Url.shorten
	# end

	scope :top, -> { order('counter DESC').limit(10) }
	
	validates :url, :presence => true, :uniqueness => true, :format => {:with => REGEX_URL, :multiline => true}

	def self.shorten(host_name)
		letters = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		string = "#{host_name}/links/" + (0...5).map { letters[rand(letters.length)] }.join
	end


end
