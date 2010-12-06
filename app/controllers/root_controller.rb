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
      @entry = Url.find_by_address(p)
      if @entry.nil?
        @entry = Url.create(params[:url])
        @entry.remote_ip = request.ip
        @entry.save!
        flash[:notice] = "URL minified"
      else
        flash[:notice] = "URL already minified"
      end
      respond_to do |format|
        format.html 
        format.json {render :json => @entry.to_json(request.host) }
        format.xml  {render :xml => @entry.to_xml(request.host) }
        format.js
      end      
    end
  end

  def show
    @entry = Url.find_by_mini(params[:mini])
    if @entry.nil?
      flash[:notice] = "URL not found"
      redirect_to root_path
    end
    respond_to do |format|
	    format.html 
      format.json {render :json => @entry.to_json(request.host) }
      format.xml  {render :xml => @entry.to_xml(request.host) }
    end  
  end
  
  def show_all
    @urls = Url.all
    @views = @urls.inject(0){|s,u|s + u.views.all.count}
  end  
  
  #this will provide stats info about the url
  def info
    @entry = Url.find_by_mini(params[:mini])
    @chart = @entry.get_stats_chart
    if @entry.nil?
      flash[:notice] = "URL not found"
      redirect_to root_path
    end
    respond_to do |format|
      format.html 
      format.json {render :json => @entry.to_json(request.host) }
      format.xml  {render :xml => @entry.to_xml(request.host) }
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
        :referrer => request.env["HTTP_REFERER"],
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
