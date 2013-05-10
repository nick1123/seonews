require 'uri'                                                                      
require 'open-uri'

class UrlCrawler
  def crawl(url)
    begin 
      html_content = nil
      final_url = nil
      open(url) do |h|
        html_content = h.read
        final_url = h.base_uri.to_s
      end
    rescue Exception => e
      puts "Something went wrong with url: #{url}"
      html_content = nil
      final_url = nil
    end

    return [html_content, final_url]
  end
end

