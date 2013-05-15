class UrlExtractor
  def from_rss_feed(html_content)
    return html_content.scan(/(http:\/\/.*?)"/i).flatten 
  end

  def from_twitter_feed(html_content)
    hash = ::JSON.parse(html_content)
    urls = []
    hash["results"].each do |result|
      tweet = result['text'] + ' '
      url_results = tweet.scan(/(http:\/\/.*?)\s/i).flatten
      if url_results.size > 0
        urls << url_results
      end
    end

    return urls.flatten.uniq
  end
end 
