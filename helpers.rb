# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def validate_url(url)
    true
  end    
end

