class CreateTwitterUrls < ActiveRecord::Migration
  def change
    create_table :twitter_urls do |t|
      t.string "url"
      t.boolean "crawled", :default => false
      t.timestamps
    end
  end
end
