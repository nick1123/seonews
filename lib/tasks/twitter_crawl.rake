require 'uri'

namespace :twitter_crawl do
  desc "crawl twitter profiles and look for new urls"
  task :profiles => :environment do
    handles = [
      "problogger",
      "DannyIny",
      "derekhalpern",
      "STSpikePromo",
      "dukeo",
      "rustybrick",
      "sejournal",
      "dan_shure",
      "seo",
      "SEO_Web_Design",
      "seobook",
      "sengineland",
      "dannysullivan",
      "seocom",
      "AnaTrafficCafe",
    ]
    url_crawler = UrlCrawler.new
    url_extractor = UrlExtractor.new 
    url_validator = UrlValidator.new
    handles.each do |handle|
      url = "http://search.twitter.com/search.json?q=#{handle}&rpp=100&include_entities=false&result_type=recent"
      html_content, final_url = url_crawler.crawl(url)
      urls_extracted = url_extractor.from_twitter_feed(html_content)
      
      urls_extracted.each do |url| 
        tu = TwitterUrl.find_or_create_by_url(url)
        tu.twitter_handle = handle
        tu.save
      end

      puts "Crawling #{handle}"
      puts "Found #{urls_extracted.size} urls"
      puts ""
    end
    
    puts TwitterUrl.count
  end

  desc "crawl twitter urls"
  task :urls => :environment do
    url_crawler = UrlCrawler.new
    url_validator = UrlValidator.new
    html_extractor = HtmlExtractor.new
    tus = TwitterUrl.where(:crawled => false)
    tus_size = tus.size
    tus.shuffle.each_with_index do |tu, index|
      begin
        html_content, final_url = url_crawler.crawl(tu.url)
       
        if final_url.blank?
          puts "*** #{index}/#{tus_size}: final_url is empty & html_content.size: #{html_content.to_s.size} :("
        else
          final_url = url_validator.rm_utm(final_url)
          final_url = url_validator.rm_after_pound(final_url)
          final_url = url_validator.rm_quotes(final_url)

          title = html_extractor.title(html_content)


          if CrawledUrl.where(:url => final_url).blank?
            cu = CrawledUrl.create(:url => final_url, :title => title)
            cu.clean_title
            cu.computer_classify_for_seo
            cu.twitter_handle = tu.twitter_handle
            cu.domain = URI.parse(final_url).host
            cu.save
            puts "*** #{index}/#{tus_size}: new record created: #{cu.title_clean}"
            puts cu.url
            puts cu.domain
            puts cu.computer_classified_seo_status
          else
            puts "*** #{index}/#{tus_size}: skipped (dup): #{title}"
          end
        end
        tu.crawled = true
        tu.save
      rescue Exception => e
        puts e
        puts e.backtrace
        tu.crawled = true
        tu.save
        exit
      end
     
      #sleep(2)
      puts ""
    end

    puts "#{CrawledUrl.count} Crawled Urls"
    puts "#{CrawledUrl.where(:computer_classify_status_id => ::CrawledUrl::STATUS_COMPUTER_CLASSIFY_SEO).size} SEO Crawled Urls"
  end
end
