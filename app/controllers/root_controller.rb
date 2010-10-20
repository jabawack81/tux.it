class RootController < ApplicationController

  respond_to :html, :xml, :json

  def index
  end
  
  def create
    redirect_to root_path  if params[:url][:address].empty?
    @showurl = Url.find_by_address(params[:url][:address])
    if @showurl.nil?
      @showurl = Url.create(params[:url])
      @showurl.remote_ip = request.ip
      @showurl.save!
      flash[:notice] = "URL minified"
    else
      flash[:notice] = "URL already minified"
    end
    respond_to do |format|
      format.html {redirect_to minified_path(:mini => @showurl.minified) }
      format.json {render :json => @showurl.to_json(request.host) }
      format.xml  {render :xml => @showurl.to_xml(request.host) }
    end    
  end

  def show
    @showurl = Url.find_by_mini(params[:mini])
    if @showurl.nil?
      flash[:notice] = "URL not found"
      redirect_to root_path
    end
    respond_to do |format|
      format.html 
      format.json {render :json => @showurl.to_json(request.host) }
      format.xml  {render :xml => @showurl.to_xml(request.host) }
    end    
  end
  
  #this will provide stats info about the url
  def info
    @showurl = Url.find_by_mini(params[:mini])

    @hit = Array.new
    (1..30).each do |n|
    m = n-1
    @hit[n]=@showurl.views.where(:created_at => (Time.now.midnight - n.day)..(Time.now.midnight - m.day)).size
    end
    @hit[0] = @showurl.views.where(:created_at => (Time.now.midnight - 1.day)..Time.now).size
    @hit.reverse!
    @hit_s = ""
    @hit.each {|h| @hit_s += h.to_s + "," }
    @hit_s.chop!
    @max_hit = @hit.sort[@hit.length-1].to_s
   #Arrays with the days of the last month (one every five) to display in chart
    @days = ""
    (0..6).each do |n|
    m = (6-n)*5
    @days += "|"+ (Time.now.midnight - m.day).strftime("%d %b")
    end

    @chart = "http://chart.apis.google.com/chart?chxl=0:"+@days+"&chxp=0,1,5,10,15,20,25,30&chxr=0,1,30&chxs=0,000000,12.5,0,l,676767&chxt=x&chs=400x300&cht=lc&chco=1500FF&chds=0,"+@max_hit+"&chd=t:"+@hit_s+"&chls=1&chtt=Page+views+in+the+last+30+days"
    
    if @showurl.nil?
      flash[:notice] = "URL not found"
      redirect_to root_path
    end
    respond_to do |format|
      format.html 
      format.json {render :json => @showurl.to_json(request.host) }
      format.xml  {render :xml => @showurl.to_xml(request.host) }
    end
  end
  
  def qr
    redirect_to "http://chart.apis.google.com/chart?cht=qr
&chs=75x75&choe=UTF-8&chld=H&chl="+request.host+"/"+params[:mini]
  end
  
  def mini 
    url = Url.find_by_mini(params[:mini])
    if url
      View.create!(
        :url_id => url.id,
        :access_time => Time.now,
        :referrer => request.env["REFERER"],
        :user_agent => request.env["HTTP_USER_AGENT"],
        :remote_ip => request.remote_ip )
        
      redirect_to url.address
    else
      flash[:notice] = "url not found"
      redirect_to root_path
    end
  end
  
  def new
    
  end
end
