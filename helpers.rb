# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def validate_url(url)
    true
  end  
  
  def add_http_to_url_if_needed(address)
    address.match('^https?:\/\/') ? address : "http://#{address}"   
  end    
end

