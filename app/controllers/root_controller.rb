class RootController < ApplicationController

  respond_to :html, :xml, :json, :rjs

  def index
  end
  
  def create
    p = params[:url][:address]
    if p.empty? || !Url.has_valid_TLD?(p)
      respond_to do |format|
        format.html {redirect_to root_path}  
        format.js {render :inline => "alert('Please insert a valid URL')"}
      end
    else
      @showurl = Url.find_by_address(p)
      if @showurl.nil?
        @showurl = Url.create(params[:url])
        @showurl.remote_ip = request.ip
        @showurl.save!
        flash[:notice] = "URL minified"
      else
        flash[:notice] = "URL already minified"
      end
      respond_to do |format|
        format.html 
        format.json {render :json => @showurl.to_json(request.host) }
        format.xml  {render :xml => @showurl.to_xml(request.host) }
        format.js
      end      
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
  
  def show_all
  end
  
  #this will provide stats info about the url
  def info
    @showurl = Url.find_by_mini(params[:mini])
    @chart = @showurl.get_stats_chart
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
