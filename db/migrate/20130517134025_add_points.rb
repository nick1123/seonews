class AddPoints < ActiveRecord::Migration
  def up
    add_column :crawled_urls, :clicks, :integer, :default => 0
    add_column :crawled_urls, :points, :integer, :default => 100
    add_column :crawled_urls, :votes, :integer, :default => 0
  end

  def down
  end
end
