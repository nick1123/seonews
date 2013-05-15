class TwitterCrawler
  attr_reader :url_crawler

  def initialize
    @url_crawler = UrlCrawler.new
  end

  def crawl(twitter_handle)
    url = "http://search.twitter.com/search.json?q=#{twitter_handle}&rpp=100&include_entities=false&result_type=recent"

  end
end
