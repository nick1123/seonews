class CreateCrawledUrls < ActiveRecord::Migration
  def change
    create_table :crawled_urls do |t|
      t.string   "url"
      t.string   "domain"                                                            
      t.string   "title"                                                             
      t.boolean  "had_problem",      :default => false                               

      t.boolean "is_processed", :default => false
      t.timestamps
    end
  end
end
