class CrawledUrl < ActiveRecord::Base
  attr_accessible :url, :title, :title_clean, :twitter_handle

  STATUS_COMPUTER_CLASSIFY_NONE    = 0
  STATUS_COMPUTER_CLASSIFY_SEO     = 1
  STATUS_COMPUTER_CLASSIFY_NOT_SEO = 2

  def clean_title
    self.title_clean = self.title
  
    pipe_begin = self.title_clean.index("|")
    self.title_clean = self.title[0..(pipe_begin-1)] if pipe_begin
  end

  def computer_classify_for_seo
    self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_NOT_SEO # Default

    title_modified = self.title_clean.downcase.gsub('linkedin', '')
    single_keywords = [
      'algorithm',
      'link',
      'page rank',
      'pagerank',
      'panda',
      'penguin',
      'seo',
    ]

    single_keywords.each do |single_keyword|
      if title_modified.index(single_keyword)
        self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_SEO
        return
      end
    end

    if title_modified.index('google')
      if title_modified.index('rank') || title_modified.index('authority') || title_modified.index('spam')
        self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_SEO
        return
      end
    end

  end

  def computer_classified_seo_status
    return "SEO? Not Classified" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_NONE
    return "SEO? Yes" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_SEO
    return "SEO? No" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_NOT_SEO
  end

  def self.last_24_hours
    time_begin = Time.now
    time_end = 24.hours.ago
    #return CrawledUrl.where(:created_at => time_begin..time_end, 
    #                        :computer_classify_status_id => STATUS_COMPUTER_CLASSIFY_SEO)
    return CrawledUrl.where(:computer_classify_status_id => STATUS_COMPUTER_CLASSIFY_SEO)
  end
end
