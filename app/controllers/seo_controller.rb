class SeoController < ApplicationController

  def index
    @cu = CrawledUrl.last_24_hours
  end

  def url_redirect
    cu = CrawledUrl.find(params[:cu_id])                                                                                                                                                                         
    cu.increment_clicks                                                                              
    redirect_to cu.url   
  end
end
