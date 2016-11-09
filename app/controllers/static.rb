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
	if Url.find_by('long_url = ?', params[:url])
		redirect to("/urls/index")
	end

	@url = Url.new(:long_url => params[:url])

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
		@uri = Url.find_by("short_url = ?", params[:link])
		redirect @uri.long_url if @uri
end
