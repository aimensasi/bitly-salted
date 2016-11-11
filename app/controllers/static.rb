require 'rack-flash'
require "sinatra/content_for"
require 'json'

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

post '/urls/create' do
	#if url already exist
  if request.accept?('application/x-www-form-urlencoded')
  	@url =	Url.find_by('url = ?', params[:url])
  	if @url
      return {status: '208', url: @url.url, short_form: @url.short_form, counter: @url.counter}.to_json
  	end
    short_form = Url.shorten(request.env['HTTP_HOST'])
  	@url = Url.new({:url => params[:url], :short_form => short_form})
  	if @url.save
        @urls
  	   {status: '200', message: 'Short Url Was Created Successfully', url: @url.url, short_form: @url.short_form, counter: @url.counter}.to_json
  	else
			 {status: '400', message: @url.errors.full_messages.first}.to_json
  	end
  end#if request is in type urlencoded
end


get '/links/:link' do 
    url = "#{request.env['HTTP_HOST']}/#{params[:link]}"
		@url = Url.find_by("short_form = ?", url)

		@url.update(:counter => @url.counter += 1)
		redirect @url.url if @url
end
