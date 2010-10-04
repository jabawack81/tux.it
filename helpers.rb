# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def validate_url(url)
    true
  end
  
  def shuffle(arr)
    arr.size.downto(1) { |n| arr.push arr.delete_at(rand(n)) }
    arr
  end
end

