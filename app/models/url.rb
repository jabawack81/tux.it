class Url < ActiveRecord::Base
  has_many  :views
  before_save :fix_address
  validates_presence_of :address

  #characters mapping to ID, base 65
  CHARS = ["3", "W", "b", "m", "w", "9", "d", "B", "p", 
           "0", "o", "u", "y", "7", "V", "N", "a", "s", 
           "D", "v", "_", "~", "k", "i", "8", "n", "P", 
           "R", "Y", "f", "Q", "I", "T", "F", "h", "O", 
           "l", "U", "X", "g", "t", "z", "6", "C", "K", 
           "2", "-", "e", "c", "Z", "H", "r", "M", "A", 
           "1", "G", "j", "4", "5", "x", "E", "S", "q", 
           "L", "J"]
            
  TLDS = ['ac','ad','ae','aero','af','ag','ai','al','am','an','ao','aq','ar','arpa','as','asia','at','au','aw','ax','az',
	'ba','bb','bd','be','bf','bg','bh','bi','biz','bj','bm','bn','bo','br','bs','bt','bv','bw','by','bz','ca','cat',
	'cc','cd','cf','cg','ch','ci','ck','cl','cm','cn','co','com','coop','cr','cu','cv','cx','cy','cz','de','dj','dk',
	'dm','do','dz','ec','edu','ee','eg','er','es','et','eu','fi','fj','fk','fm','fo','fr','ga','gb','gd','ge','gf','gg',
	'gh','gi','gl','gm','gn','gov','gp','gq','gr','gs','gt','gu','gw','gy','hk','hm','hn','hr','ht','hu','id','ie','il',
	'im','in','info','int','io','iq','ir','is','it','je','jm','jo','jobs','jp','ke','kg','kh','ki','km','kn','kp','kr',
	'kw','ky','kz','la','lb','lc','li','lk','lr','ls','lt','lu','lv','ly','ma','mc','md','me','mg','mh','mil','mk','ml',
	'mm','mn','mo','mobi','mp','mq','mr','ms','mt','mu','museum','mv','mw','mx','my','mz','na','name','nc','ne','net',
	'nf','ng','ni','nl','no','np','nr','nu','nz','om','org','pa','pe','pf','pg','ph','pk','pl','pm','pn','pr','pro','ps',
	'pt','pw','py','qa','re','ro','rs','ru','rw','sa','sb','sc','sd','se','sg','sh','si','sj','sk','sl','sm','sn','so',
	'sr','st','su','sv','sy','sz','tc','td','tel','tf','tg','th','tj','tk','tl','tm','tn','to','tp','tr','travel','tt',
	'tv','tw','tz','ua','ug','uk','us','uy','uz','va','vc','ve','vg','vi','vn','vu','wf','ws','xn--0zwm56d','xn--11b5bs3a9aj6g',
	'xn--80akhbyknj4f','xn--9t4b11yi5a','xn--deba0ad','xn--fiqs8s','xn--fiqz9s','xn--fzc2c9e2c','xn--g6w251d','xn--hgbk6aj7f53bba',
	'xn--hlcj6aya9esc7a','xn--j6w193g','xn--jxalpdlp','xn--kgbechtv','xn--kprw13d','xn--kpry57d','xn--mgbaam7a8h',
	'xn--mgbayh7gpa','xn--mgberp4a5d4ar','xn--o3cw4h','xn--p1ai','xn--pgbs0dh','xn--wgbh1c','xn--xkc2al3hye2a',
	'xn--ygbi2ammx','xn--zckzah','ye','yt','za','zm','zw']            
  
  def minified
    num = self.id
    str = ''
    base = CHARS.size
    while num > 0 do
      str << CHARS[num % base]
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
      next unless CHARS.include? c
      url_id += CHARS.index(c) * (CHARS.size**pos)
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

  #TODO: convert to model validation
  def self.has_valid_TLD?(address) 
    #url = URI.parse address
    #TLDS.member? url.host.split('.').last
    true
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
