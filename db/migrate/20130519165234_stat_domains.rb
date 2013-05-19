class StatDomains < ActiveRecord::Migration
  def change
    create_table "stat_domains", :force => true do |t|
      t.string   "domain"
      t.integer   "total", :default => 0
      t.integer   "total_seo", :default => 0
      t.integer   "total_not_seo", :default => 0
      t.integer   "points", :default => 0
      t.integer   "points_avg", :default => 0
      t.integer   "points_avg_seo", :default => 0
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
    end
  end
end
