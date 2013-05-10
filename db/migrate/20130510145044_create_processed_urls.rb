class CreateProcessedUrls < ActiveRecord::Migration
  def change
    create_table :processed_urls do |t|
      t.integer  "crawled_url_id"      
      t.string   "url"                                                                                                                                                                                          
      t.string   "domain"                                                            
      t.string   "title"                                                             
      t.boolean  "had_problem",      :default => false                               

      t.timestamps
    end
  end
end
