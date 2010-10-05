require 'dm-core'
require 'dm-aggregates'
require './urls.rb'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///tmp/tuxit.sqlite3')

class Url  
  include DataMapper::Resource
  include UrlMinifier
  
  before :save, :fix_address

  property :id,         Serial
  property :address,    Text
  property :remote_ip,  String
  property :created,    DateTime

  has n, :views
  
  def mini
    UrlMinifier.to_mini(@id)
  end
  
  def self.get_by_mini(mini)
    get UrlMinifier.to_num(mini)
  end
  
  def self.get_by_address(url)
    get :url => check_http_address(url)
  end
  
  private 
  def self.check_http_address(url)
    url = "http://#{url}" unless url.match('^https?:\/\/')
    url
  end
  
  def fix_address
    @address = Url.check_http_address(@address)
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