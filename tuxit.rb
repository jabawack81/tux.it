#require 'rubygems'
require 'sinatra'
require './datamodels.rb'
require './helpers.rb'


get '/' do
  redirect 'http://tux.it'  if ENV['url'] == 'www.tux.it'
  erb :index
end

get '/show_all' do
  @urls = Url.all
  erb :show_all
end

get '/:mini' do
  url = Url.get_by_mini(params[:mini])
  pass if url.nil?
  if url
    View.create(
      :url => url,
      :access_time => Time.now, 
      :referrer => request.referer,
      :user_agent => request.user_agent,
      :remote_ip => request.ip
    redirect url.address, 301
  else
    redirect '/'
  end
end

post '/' do
  @url = Url.create :address => params[:url], :created => Time.now
  erb :created
end

not_found do
  'Url unknown'
end

