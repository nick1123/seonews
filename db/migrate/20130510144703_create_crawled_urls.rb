class CreateCrawledUrls < ActiveRecord::Migration
  def change
    create_table :crawled_urls do |t|
      t.string   "url"
      t.boolean "is_processed"
      t.timestamps
    end
  end
end
