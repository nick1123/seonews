# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130517134025) do

  create_table "crawled_urls", :force => true do |t|
    t.string   "url"
    t.string   "domain"
    t.string   "twitter_handle"
    t.string   "title"
    t.string   "title_clean"
    t.integer  "computer_classify_status_id", :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "clicks",                      :default => 0
    t.integer  "points",                      :default => 0
    t.integer  "points_initial",                      :default => 0
    t.integer  "votes",                       :default => 0
  end

  add_index "crawled_urls", ["url"], :name => "index_crawled_urls_on_url"  

  create_table "twitter_urls", :force => true do |t|
    t.string   "url"
    t.string   "twitter_handle"
    t.boolean  "crawled",        :default => false
    t.boolean  "had_problem",                 :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "twitter_urls", ["url"], :name => "index_twitter_urls_on_url"  

end
