# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100506212015) do

  create_table "failed_twitts", :force => true do |t|
    t.string   "station_string"
    t.datetime "date"
    t.string   "user"
    t.integer  "twitter_id",     :limit => 8
    t.integer  "line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", :force => true do |t|
    t.text     "comment"
    t.datetime "date"
    t.string   "user"
    t.integer  "twitter_id",     :limit => 8
    t.integer  "line_id"
    t.string   "station_string"
    t.float    "lat"
    t.float    "long"
    t.integer  "station_id"
  end

  create_table "lines", :force => true do |t|
    t.integer "number"
    t.string  "name"
  end

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.string   "nicename"
    t.integer  "line_id"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
