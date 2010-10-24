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

  def get_stats_chart
    hit = Array.new(size=31,0)
    self.views.where(:created_at => (Time.now.midnight - 30.day)..Time.now).each do |n| 
	hit[(Time.now.day - n.created_at.day)%31] += 1
	end
    hit.reverse!
    hit_s = hit.join(',')
    days = (0..6).inject('') {|d,n| d + "|" + (Time.now.midnight - ((6-n)*5).day).strftime("%d %b")}
    "http://chart.apis.google.com/chart?chxl=0:"+days+"&chxp=0,1,5,10,15,20,25,30&chxr=0,1,30&chxs=0,000000,12.5,0,l,676767&chxt=x&chs=400x300&cht=lc&chco=1500FF&chds=0,"+hit.max.to_s+"&chd=t:"+hit_s+"&chls=1&chtt=Page+views+in+the+last+31+days"
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
