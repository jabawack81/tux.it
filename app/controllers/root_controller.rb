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
      flash[:notice] = "URL already present"
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
    redirect_to "http://chart.apis.google.com/chart?cht=qr&chs=75x75&choe=UTF-8&chld=H&chl="+request.host+"/"+params[:mini]
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
