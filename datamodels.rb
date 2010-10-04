require 'dm-core'
require './urls.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://tmp/tuxit.db')

class Url  
  include DataMapper::Resource
  include UrlMinifier
  
  property :id,         Serial
  property :address,    String
  property :remote_ip,  String
  property :created,    DateTime

  has n, :views
  
  def address
    if @address.match('^https?:\/\/')
      return @address
    else
      return "http://#{@address}"
    end
  end

  def mini
    to_mini(@id)
  end
  
end

class View
  include DataMapper::Resource
  
  property :id, Serial
  property :access_time, DateTime
  property :referrer, String
  property :user_agent, String
  property :remote_ip, String
  
  belongs_to :url
end