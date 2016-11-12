require 'rack-flash'
require "sinatra/content_for"
require 'json'
require 'net/http'

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
    puts "URL #{params[:url]} #{URI(params[:url]).inspect}"
    
    #parsing the given url to make sure it's valid
    url = "HTTP://#{params[:url]}" if URI(params[:url]).scheme.nil?
    domain_name = URI(url).host.downcase
    domain_name = domain_name.start_with?('www.') ? domain_name[4..-1] : domain_name

    #if url already exist
  	@url =	Url.find_by('url = ?', domain_name)
  	if @url
      return {status: '208', url: @url.url, short_form: @url.short_form, counter: @url.counter}.to_json
  	end

    #preparing the short url to match the schema://host_name/short_url 
    host_name = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    short_form = Url.shorten(host_name)

    #create a new URl and save
  	@url = Url.new({:url => domain_name, :short_form => short_form})
  	if @url.save
  	   {status: '200', message: 'Short Url Was Created Successfully', url: @url.url, short_form: @url.short_form, counter: @url.counter}.to_json
  	else
			 {status: '400', message: @url.errors.full_messages.first}.to_json
  	end
  end#if request is in type urlencoded
end

get '/links/:link' do 
    url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}/links/#{params[:link]}"
		@url = Url.find_by("short_form = ?", url)
		@url.update(:counter => @url.counter += 1)

    uri = URI(@url.url)
    uri = "HTTP://#{uri}" if uri.scheme.nil?

		redirect uri if @url
end
