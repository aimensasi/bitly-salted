require 'rack-flash'
require "sinatra/content_for"

enable :sessions
use Rack::Flash

before do 
 @urls = Url.top
end

get '/' do
  erb :"static/index"
end

get '/urls' do
	erb :"static/index"
end

get '/urls/:id' do 
	@url = Url.find(params[:id])
	erb :'static/index'
end


post '/urls/create' do
	#if url already exist
  @url =	Url.find_by('url = ?', params[:url])
	if @url
		redirect to("/urls/#{@url.id}")
	end

	@url = Url.new(:url => params[:url])

	if @url.save
		flash[:notice] = "Short Url Was Created Successfully"
		redirect to("/urls/#{@url.id}")
	else
		flash[:error] = @url.errors.full_messages.first
		redirect to("/urls")
	end
end

get '/links/:link' do 
		@url = Url.find_by("short_form = ?", params[:link])
		@url.update(:counter => @url.counter += 1)
		redirect @url.url if @url
end
