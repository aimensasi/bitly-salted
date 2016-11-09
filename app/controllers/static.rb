require 'rack-flash'

enable :sessions
use Rack::Flash


get '/' do
  erb :"static/new"
end

get '/urls' do
	erb :"static/new"
end

post '/urls/create' do
	#if url already exist
	# if Url.find_by('url = ?', params[:url])
	# 	redirect to("/urls/index")
	# end

	@url = Url.new(:url => params[:url])

	if @url.save
		flash[:notice] = "Short Url Was Created Successfully"
		redirect to("/urls/index")
	else
		flash[:error] = @url.errors.full_messages.first
		erb :"static/new"
	end
end

get '/urls/index' do
	@urls = Url.all
	erb :"static/index"
end

get '/urls/:link' do 
		@url = Url.find_by("short_form = ?", params[:link])
		 
		@url.update(:counter => @url.counter += 1)
		# puts "counter #{counter}"
		redirect @url.url if @url
end
