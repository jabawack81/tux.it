module ApplicationHelper
  def flash_div
    raw flash.keys.collect{|k| "<div style='text-align:center' class=\"flash #{k}\">#{flash[k]}</div>" }.join unless flash.keys.empty?
  end
  
  def block_header
    @header
  end
end
