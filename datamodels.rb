require 'dm-core'


#DataMapper.setup(:default, "appengine://auto")
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://my.db')

class Url  
  include DataMapper::Resource
  @@chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['_','-']
  
  property :id,         Serial
  property :address,    String
  property :mini,       String, :unique => true
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
  
  before :save do  
    mini = ''
    4.times {mini += get_rnd_char}
    @mini = mini
  end
  
  private
  def get_rnd_char
    @@chars[Kernel.rand(@@chars.size)]
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