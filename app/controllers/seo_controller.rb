class SeoController < ApplicationController

  def index
    @cu = CrawledUrl.last_24_hours
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
