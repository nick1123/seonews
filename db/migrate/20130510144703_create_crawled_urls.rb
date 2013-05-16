class CreateCrawledUrls < ActiveRecord::Migration
  def change
    create_table :crawled_urls do |t|
      t.string   "url"
      t.string   "domain"                                                            
      t.string   "twitter_handle"                                                            
      t.string   "title"                                                             
      t.string   "title_clean"                                                             
      t.integer  "computer_classify_status_id", :default => 0
      t.boolean  "had_problem",      :default => false                               
      t.timestamps
    end
  end
end
