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
    :referrer => request.referer,
    :user_agent => request.user_agent,
    :remote_ip => request.ip)
    
  redirect url.address, 301
end

post '/' do
  @url = Url.create(
      :address => params[:url], 
      :created => Time.now, 
      :remote_ip => request.ip)
  erb :created
end

not_found do
  'Url unknown'
end

