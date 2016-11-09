class Url < ActiveRecord::Base
	# This is Sinatra! Remember to create a migration!

	before_create { self.short_url = shorten }
	validates :long_url, :presence => true, :uniqueness => true

	def shorten
		letters = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		string = (0...5).map { letters[rand(letters.length)] }.join
		short_url = string
	end
end
