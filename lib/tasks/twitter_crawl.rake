require 'uri'

def crawl_profiles
  handles = [
  "aaronwall",
  "AnaTrafficCafe",
  "briansolis",
  "copyblogger",
  "DannyIny",
  "dan_shure",
  "dannysullivan",
  "davepeck",
  "derekhalpern",
  "dharmesh",
  "ducttape",
  "dukeo",
  "iGoByDoc",
  "KISSmetrics",
  "mattcutts",
  "PatFlynn",
  "problogger",
  "randfish",
  "rustybrick",
  "sejournal",
  "sengineland",
  "seobook",
  "seocom",
  "SEOmoz",
  "STSpikePromo",
  "TiceWrites",
  "unmarketing",
  "WritingH",
  ]
  url_crawler = UrlCrawler.new
  url_extractor = UrlExtractor.new 
  url_validator = UrlValidator.new
  handles.each do |handle|
    begin
      url = "http://search.twitter.com/search.json?q=#{handle}&rpp=20&include_entities=false&result_type=recent"
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
    rescue Exception => e
      puts e
      puts e.backtrace
    end
  end

  puts TwitterUrl.count
end

def crawl_urls
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

          sd = StatDomain.find_or_create_by_domain(cu.domain)
          cu.points         = sd.points_avg_seo
          cu.points_initial = sd.points_avg_seo
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
      tu.crawled     = true
      tu.had_problem = true
      tu.save
    end

    #sleep(2)
    puts ""
  end

  puts "#{CrawledUrl.count} Crawled Urls"
  puts "#{CrawledUrl.where(:computer_classify_status_id => ::CrawledUrl::STATUS_COMPUTER_CLASSIFY_SEO).size} SEO Crawled Urls"
end

def compute_stats_domain(cu)
    sd = StatDomain.find_or_create_by_domain(cu.domain)
    sd.total += 1
    sd.points += (cu.points - cu.points_initial)

    if cu.is_seo?
      sd.total_seo += 1
    else
      sd.total_not_seo += 1
    end

    sd.compute_averages
    sd.save
end

def compute_stats_twitter_handle(cu)
    th = StatTwitterHandle.find_or_create_by_handle(cu.twitter_handle)
    th.total += 1
    th.points += (cu.points - cu.points_initial)

    if cu.is_seo?
      th.total_seo += 1
    else
      th.total_not_seo += 1
    end

    th.compute_averages
    th.save
end

def compute_stats
  StatDomain.delete_all
  StatTwitterHandle.delete_all
  CrawledUrl.all.each do |cu|
    compute_stats_domain(cu)
    compute_stats_twitter_handle(cu)
  end
end

namespace :twitter_crawl do
  desc "crawl twitter profiles and look for new urls"
  task :profiles => :environment do
    crawl_profiles
  end

  desc "crawl twitter urls"
  task :urls => :environment do
    crawl_urls
  end

  desc "compute stats"
  task :compute_stats => :environment do
    compute_stats
  end

  desc "kill_handle_data"
  task :kill_handle_data => :environment do
    handles = [
      "seo",
      "SEO_Web_Design",
    ]
puts CrawledUrl.count
    handles.each do |handle|
      TwitterUrl.delete_all(["twitter_handle = ?", handle])
      CrawledUrl.delete_all(["twitter_handle = ?", handle])
    end
puts CrawledUrl.count
  end



  desc "crawl twitter profiles & urls in an infinite loop"
  task :profiles_and_urls => :environment do
    sleep_time = 3_600
    while true do
      compute_stats
      crawl_profiles
      crawl_urls
      compute_stats
      puts "sleeping for #{sleep_time} seconds"
      sleep(sleep_time)
    end
  end
end
