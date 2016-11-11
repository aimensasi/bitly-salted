helpers do 
	# truncate a string that exceed the given length
	def truncate(str, option = {})
		max_length = option[:length] ||= 30
		end_string = option[:end_string] ||= '...'

			if str.kind_of? String
				return if str.nil?
				if str.length > max_length
					str.slice!(max_length..str.length)
					str + end_string
				end
				str
			end
	end
end