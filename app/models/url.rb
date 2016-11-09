class Url < ActiveRecord::Base
	# This is Sinatra! Remember to create a migration!
	REGEX_URL = /^(https|http):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
	
	before_create do 
		self.short_form = shorten
	end
	
	validates :url, :presence => true, :uniqueness => true, :format => {:with => REGEX_URL, :multiline => true}

	def shorten
		letters = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		string = (0...5).map { letters[rand(letters.length)] }.join
	end
end
