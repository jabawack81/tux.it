module RootHelper
      
  def qrcode_url(url)
    "http://chart.apis.google.com/chart?cht=qr&chs=75x75&choe=UTF-8&chld=H&chl="+request.host+"/"+url.minified
  end
  
  def qrcode_image_tag(url)
    raw "<img src=\"#{qrcode_url(url)}\" alt=\"#{request.host+'/'+url.minified} QR code\"/>"
  end  
end
