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
    puts urls.inspect
  end
end
