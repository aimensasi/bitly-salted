require 'uri'
require 'net/http'

class Url < ActiveRecord::Base

	
	DOMAIN_EXTENTION = /\.[a-zA-Z]{2,}/
	
	scope :top, -> { order('counter DESC').limit(10) }
	
	validates :url, :presence => true, :uniqueness => true, :if => :is_valid?


	def self.shorten(host_name)
		letters = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		string = "#{host_name}/links/" + (0...5).map { letters[rand(letters.length)] }.join
	end

	def is_valid?
		#if url does not has a domain extenstion
		if url !~ DOMAIN_EXTENTION
			errors.add(:url, 'Is Invaild')	
		end
	end

end
