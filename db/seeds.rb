require "csv"
FILE_NAME =  APP_ROOT.join('db/', 'urls')
class ImportUrls
	def self.import
		Url.delete_all
		urls = []
		i = 0
		CSV.foreach(FILE_NAME) do |csv_row|
			# puts csv_row
			url_row = csv_row.first.gsub(/[(]/, "").gsub(/[)]/, "")
			url_row = "'#{url_row}'"
			# puts url_row
			url_row = url_row.insert(csv_row.first.length , ", '#{Url.shorten}', LOCALTIMESTAMP, LOCALTIMESTAMP")

			# puts "(#{url_row})"								 
			urls.push("(#{url_row})")
			# return
		end


		Url.transaction do
			Url.connection.execute "INSERT INTO urls (url, short_form, created_at, updated_at) VALUES #{urls.join(', ')}"
		end
	end

end 