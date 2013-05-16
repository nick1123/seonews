class CreateCrawledUrls < ActiveRecord::Migration
  def change
    create_table :crawled_urls do |t|
      t.string   "url"
      t.string   "domain"                                                            
      t.string   "title"                                                             
      t.string   "title_clean"                                                             
      t.integer  "human_classify_status_id", :default => 0
      t.integer  "computer_classify_status_id", :default => 0
      t.boolean  "had_problem",      :default => false                               
      t.boolean "is_processed", :default => false
      t.timestamps
    end
  end
end
