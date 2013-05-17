class SeoController < ApplicationController

  def index
    @cu = CrawledUrl.last_24_hours
  end
end
