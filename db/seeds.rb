require "csv"
FILE_NAME =  APP_ROOT.join('db/', 'urls')
class ImportUrls
	def self.import
		Url.delete_all
		urls = []
		i = 0
		CSV.foreach(FILE_NAME) do |csv_row|
			url_row = csv_row[0].insert(csv_row[0].index(')'), ", #{Url.shorten}")
			urls.push(url_row)
		end

		Url.transaction do
			Url.connection.execute "INSERT INTO urls (url, short_form) VALUES #{urls.join(', ')}"
		end
	end

end 