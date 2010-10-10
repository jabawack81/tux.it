class Url < ActiveRecord::Base
  has_many  :views
  before_save :fix_address
  
  #characters mapping to ID, base 65
  @@chars = ["3", "W", "b", "m", "w", "9", "d", "B", "p", 
             "0", "o", "u", "y", "7", "V", "N", "a", "s", 
             "D", "v", "_", "%", "k", "i", "8", "n", "P", 
             "R", "Y", "f", "Q", "I", "T", "F", "h", "O", 
             "l", "U", "X", "g", "t", "z", "6", "C", "K", 
             "2", "-", "e", "c", "Z", "H", "r", "M", "A", 
             "1", "G", "j", "4", "5", "x", "E", "S", "q", 
             "L", "J"]
            
  def minified
    num = self.id
    str = ''
    base = @@chars.size
    while num > 0 do
      str << @@chars[num % base]
      num = num / base 
    end
    str.reverse
  end  
      
  def self.find_by_address(address)
    find( :first, 
          :conditions => ["address = ?", 
            address.match('^https?:\/\/') ? address : "http://#{address}"]
        )
  end    
  
  def self.find_by_mini(mini)
    url_id = 0
    
    pos=mini.size-1
    mini.split(//).each{ |c| 
      next unless @@chars.include? c
      url_id += @@chars.index(c) * (@@chars.size**pos)
      pos -= 1
    }

    find url_id
  end
  
  def to_json(request_host)
    {:address => address, :minified => 'http://'+request_host+'/'+minified}.to_json
  end
  
  def to_xml(request_host)
    {:address => address, :minified => 'http://'+request_host+'/'+minified}.to_xml
  end
  
  private
  def fix_address
    self.address = address.match('^https?:\/\/') ? address : "http://#{address}"
  end  
end
