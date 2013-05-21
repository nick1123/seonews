class SeoController < ApplicationController

  def index
    @last_24_hours = CrawledUrl.last_24_hours[0..24]
    @day_ago_1 = CrawledUrl.find(:all, :conditions => ["DATE(created_at) = ?", Date.today-1], :order => "points DESC", :limit => 25)
    @day_ago_2 = CrawledUrl.find(:all, :conditions => ["DATE(created_at) = ?", Date.today-2], :order => "points DESC", :limit => 25)
  end

  def newest
    @cu = CrawledUrl.newest_48_hours
  end

  def stat_domains
    @domains = StatDomain.order("domain ASC")
  end

  def url_redirect
    cu = CrawledUrl.find(params[:cu_id])                                                                                                                                                                         
    cu.increment_clicks                                                                              
    redirect_to cu.url   
  end


  def vote_up                                                                   
    cu = CrawledUrl.find(params[:cu_id])                                                                                                                                                                         
    cu.vote_up                                                                
    redirect_to :seo                      
  end                                                                           

  def vote_down                                                                 
    cu = CrawledUrl.find(params[:cu_id])                                                                                                                                                                         
    cu.vote_down                                                              
    redirect_to :seo                      
  end                                                                           

end
