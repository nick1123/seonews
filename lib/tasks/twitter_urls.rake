namespace :twitter_urls do
  desc "crawl twitter profiles and look for new urls"
  task :crawl_profile => :environment do
    handles = [
      "problogger",
      "DannyIny",
      "derekhalpern",
      "STSpikePromo",
      "dukeo",
      "rustybrick",
    ]
    url_crawler = UrlCrawler.new
    url_extractor = UrlExtractor.new 
    url_validator = UrlValidator.new
    handles.each do |handle|
      url = "http://search.twitter.com/search.json?q=#{handle}&rpp=100&include_entities=false&result_type=recent"
      html_content, final_url = url_crawler.crawl(url)
      urls_extracted = url_extractor.from_twitter_feed(html_content)
      urls_extracted.each {|url| TwitterUrl.find_or_create_by_url(url)}
      puts "Crawling #{handle}"
      puts "Found #{urls_extracted.size} urls"
      puts ""
    end
    
    puts TwitterUrl.count
  end

  desc "crawl twitter urls"
  task :crawl_urls => :environment do
    url_crawler = UrlCrawler.new
    url_validator = UrlValidator.new
    html_extractor = HtmlExtractor.new
    TwitterUrl.where(:crawled => false).shuffle.each do |tu|
      begin
        html_content, final_url = url_crawler.crawl(tu.url)
        
        final_url = url_validator.rm_utm(final_url)
        final_url = url_validator.rm_after_pound(final_url)
        final_url = url_validator.rm_quotes(final_url)

        title = html_extractor.title(html_content)

        puts tu.id
        puts title
        puts final_url
        if CrawledUrl.where(:url => final_url).blank?
          CrawledUrl.create(:url => final_url, :title => title)
          puts "*** new record created"
        else
          puts "*** skipped (dup)"
        end

        tu.crawled = true
        tu.save
      rescue Exception => e
        puts e
        tu.crawled = true
        tu.save
      end
      
      puts ""
    end
  end
end
