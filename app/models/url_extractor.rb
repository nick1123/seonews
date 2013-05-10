class UrlExtractor
  def from_rss_feed(html_content)
    return html_content.scan(/(http:\/\/.*?)"/i).flatten 
  end
end 
