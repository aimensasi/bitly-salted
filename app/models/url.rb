class Url < ActiveRecord::Base
	# This is Sinatra! Remember to create a migration!
	REGEX_URL = /^(https|http):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
	
	before_create do 
		is_valid
		self.short_form = shorten
	end
	
	validates :url, :presence => true, :uniqueness => true

	def shorten
		letters = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		string = (0...5).map { letters[rand(letters.length)] }.join
	end

	
	private
	def is_valid
		if !self.url.match(REGEX_URL)
			self.url = "https://#{self.url}"
		end
	end
end
