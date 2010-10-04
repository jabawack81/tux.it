#require 'rubygems'
require 'sinatra'
require './datamodels.rb'
require './helpers.rb'


get '/' do
  redirect 'http://tux.it'  if request.host == 'www.tux.it'
  erb :index
end

get '/show_all' do
  @urls = Url.all
  erb :show_all
end

get '/:mini' do
  url = Url.get_by_mini(params[:mini])
  pass if url.nil?

  View.create(
    :url => url,
    :access_time => Time.now,
    :referrer => request.referrer,
#    :user_agent => @request.useragent)
    :remote_ip => request.ip )
    
  redirect url.address
end

post '/' do
  @url = Url.first(:address => params[:url])
  if @url.nil?
    @url = Url.create(
        :address => params[:url], 
        :created => Time.now, 
        :remote_ip => request.ip)
  end
  erb :created
end

not_found do
  'Url unknown'
end

