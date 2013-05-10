namespace :rss_urls do
  desc "load rss urls into db" 
  task :load => :environment do
    urls = [
      "http://feeds.feedburner.com/ProbloggerHelpingBloggersEarnMoney",
      "http://feeds.feedburner.com/SearchEngineJournal",
    ]

    urls.each do |url|
      ::RssUrl.find_or_create_by_url(url)
    end
  end

  desc "crawl rss feeds and look for new urls"
  task :crawl => :environment do
    urls = ::RssUrl.all.map {|rss_url| rss_url.url}

    url_crawler = UrlCrawler.new
    url_extractor = UrlExtractor.new 
    url_validator = UrlValidator.new
    urls[0..0].each do |url|
      html_content, final_url = url_crawler.crawl(url)
      urls_extracted = url_extractor.from_rss_feed(html_content)
      urls_extracted = url_validator.scrub_rss_feed(urls_extracted)
      puts "***"
      puts urls_extracted
      puts urls_extracted.size
    end
  end
end
