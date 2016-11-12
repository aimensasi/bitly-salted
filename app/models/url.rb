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
		if url =~ DOMAIN_EXTENTION

			uri = URI.parse(url)
			uri = URI("HTTP://#{uri}") if uri.scheme.nil?
			
			if !Net::HTTP.get_response(uri).is_a?(Net::HTTPSuccess)
				errors.add(:url, 'Is Not Responding, Make sure it\'s correct and try again')
			end
		else
			#if url does not has a domain extenstion
			errors.add(:url, 'Is Invaild')	
		end
	end

end
