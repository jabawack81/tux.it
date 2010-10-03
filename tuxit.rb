#require 'rubygems'
require 'sinatra'
require './datamodels.rb'
require './helpers.rb'


get '/' do
  erb :index
end

get '/show_all' do
  @urls = Url.all
  erb :show_all
end

get '/:mini' do
  url = Url.first(:mini => params[:mini])
  pass if url.nil?
  if url
    View.create(
      :url => url,
      :access_time => Time.now, 
      :referrer => ENV['REFERRER'],
      :user_agent => ENV['USER_AGENT'],
      :remote_ip => ENV['REMOTE_ADDR'])
    redirect url.address, 302
  else
    redirect '/'
  end
end

post '/' do
  if validate_url(params[:url])
    @url = Url.create :address => params[:url], :created => Time.now
    erb :created
  else
    redirect '/'
  end
end

not_found do
  'Url unknown'
end

