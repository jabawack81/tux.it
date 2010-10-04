#TODO: to be refactored....

module UrlMinifier

  @@chars = ["3", "W", "b", "m", "w", "9", "d", "B", "p", 
             "0", "o", "u", "y", "7", "V", "N", "a", "s", 
             "D", "v", "_", "%", "k", "i", "8", "n", "P", 
             "R", "Y", "f", "Q", "I", "T", "F", "h", "O", 
             "l", "U", "X", "g", "t", "z", "6", "C", "K", 
             "2", "-", "e", "c", "Z", "H", "r", "M", "A", 
             "1", "G", "j", "4", "5", "x", "E", "S", "q", 
             "L", "J"]

  def self.to_mini(num)
    str = ''
    base = @@chars.size
    while num > 0 do
      str << @@chars[num % base]
      num = num / base 
    end
    str.reverse
  end
  
  def self.to_num(mini)
    decimal = 0
    pos=mini.size-1
    mini.split(//).each{ |c| 
      decimal += @@chars.index(c) * (@@chars.size**pos)
      pos -= 1
    }
    decimal
  end
end