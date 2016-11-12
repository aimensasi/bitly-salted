require "sinatra/content_for"
require 'json'
require 'net/http'

get '/' do
  @urls = Url.top
  erb :"static/index"
end

get '/urls' do
  @urls = Url.top
	erb :"static/index"
end

get '/get_urls' do
  @urls = Url.top.to_json
end

post '/urls/create' do
	#if url already exist
  if request.accept?('application/x-www-form-urlencoded')
    
    domain_name = params[:url].downcase
    domain_name = domain_name.start_with?('http://') ? domain_name[7..-1] : domain_name
    domain_name = domain_name.start_with?('https://') ? domain_name[8..-1] : domain_name
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
