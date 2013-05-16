class CrawledUrl < ActiveRecord::Base
  attr_accessible :url, :title, :title_clean

  STATUS_COMPUTER_CLASSIFY_NONE    = 0
  STATUS_COMPUTER_CLASSIFY_SEO     = 1
  STATUS_COMPUTER_CLASSIFY_NOT_SEO = 2

  STATUS_HUMAN_CLASSIFY_NONE    = 0
  STATUS_HUMAN_CLASSIFY_SEO     = 1
  STATUS_HUMAN_CLASSIFY_NOT_SEO = 2

  def clean_title
    self.title_clean = self.title
  end

  def computer_classify_for_seo
    self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_NOT_SEO # Default
    if self.title.index(/seo/i)
      self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_SEO
    end

    if self.title.index(/link/i)
      self.computer_classify_status_id = STATUS_COMPUTER_CLASSIFY_SEO
    end

  end

  def computer_classified_seo_status
    return "SEO? Not Classified" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_NONE
    return "SEO? Yes" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_SEO
    return "SEO? No" if self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_NOT_SEO
  end
end
