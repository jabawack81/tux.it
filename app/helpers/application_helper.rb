module ApplicationHelper
  def flash_div
    raw flash.keys.collect{|k| "<div class=\"flash #{k}\">#{flash[k]}</div>" }.join unless flash.keys.empty?
  end  
end
