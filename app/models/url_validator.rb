class UrlValidator
  MAX_LENGTH = 200

  def scrub_rss_feed(urls)
    urls.uniq!
    urls = rm_common_affiliate_site(urls)
    urls = rm_feed_burner(urls)
    urls = rm_media(urls)
    urls = too_long(urls)
    return urls
  end

  def rm_common_affiliate_site(urls)
    urls = urls.reject {|url| url.index("aweber.com")}
    urls = urls.reject {|url| url.index("chitika.com")}
    urls = urls.reject {|url| url.index("flickr.com")}
    urls = urls.reject {|url| url.index("itunes.com")}
    return urls
  end

  def rm_feed_burner(urls)
    urls.reject {|url| url.index("feedburner.com")}
  end

  def rm_media(urls)
    urls.reject {|url| url.index("wp-content/uploads")}
  end

  def too_long(urls)
    urls.reject {|url| url.size > MAX_LENGTH}
  end
end
