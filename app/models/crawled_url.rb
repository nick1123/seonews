class CrawledUrl < ActiveRecord::Base
  attr_accessible :url, :title, :title_clean, :twitter_handle

  POINTS_PER_CLICK = 1
  POINTS_PER_VOTE  = 100

  STATUS_COMPUTER_CLASSIFY_NONE    = 0
  STATUS_COMPUTER_CLASSIFY_SEO     = 1
  STATUS_COMPUTER_CLASSIFY_NOT_SEO = 2
                                                                           
  scope :created_after, lambda { |time_ago, order| { :conditions => ["created_at >= ? && computer_classify_status_id=#{STATUS_COMPUTER_CLASSIFY_SEO}", time_ago], :order => order } }

#  def self.all_for_day(day)                                         
#    self.where(:created_date => day).order('points DESC')
#  end                                                                           

  def self.by_domain(domain)                                        
    self.where(:domain => domain).order('created_at DESC')
  end                                                                           

  def self.last_24_hours                                       
    self.created_after(24.hours.ago, "points DESC")                         
  end                                                                           

  def self.newest_48_hours                                   
    self.created_after(48.hours.ago, "created_at DESC")                         
  end                                                                           

  def self.last_week                                          
    order = "created_date DESC, points DESC"                                    
    posts = self.created_after(7.days.ago, order)                   
    posts_hash = {}                                                             
    posts.each do |post|                                                        
      created_date = post.created_date                                          
      posts_hash[created_date] ||= []                                           
      posts_hash[created_date] << post                                          
    end                                                                         

    return posts_hash                                                           
  end  



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

  def increment_clicks 
    self.clicks += 1                                                            
    self.points += POINTS_PER_CLICK                                             
    self.save 
  end

  def is_seo?
    self.computer_classify_status_id == STATUS_COMPUTER_CLASSIFY_SEO
  end

  def vote_down                                                                 
    self.votes  += 1                                                        
    self.points  -= POINTS_PER_VOTE                                          
    self.save                                                                   
  end                                                                           

  def vote_up                                                                   
    self.votes  += 1                                                          
    self.points += POINTS_PER_VOTE                                            
    self.save                                                                   
  end                                                                           

end
