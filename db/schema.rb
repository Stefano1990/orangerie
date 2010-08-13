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

ActiveRecord::Schema.define(:version => 20100813080155) do

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "connections", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "status"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos", :force => true do |t|
    t.integer  "user_id"
    t.string   "sex"
    t.integer  "age_m"
    t.integer  "weight_m"
    t.integer  "height_m"
    t.string   "hair_color_m"
    t.string   "eye_color_m"
    t.string   "appearance_m"
    t.string   "bi_tendency_m"
    t.string   "sex_tend_m"
    t.boolean  "smoking_m"
    t.integer  "age_f"
    t.integer  "weight_f"
    t.integer  "height_f"
    t.string   "hair_color_f"
    t.string   "eye_color_f"
    t.string   "appearance_f"
    t.string   "bi_tendency_f"
    t.string   "sex_tend_f"
    t.boolean  "smoking_f"
    t.string   "region"
    t.string   "mobility"
    t.text     "about_us"
    t.text     "for_text"
    t.text     "like"
    t.text     "dislike"
    t.text     "looking_for"
    t.text     "to_do"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "sex"
    t.integer  "age_m"
    t.integer  "weight_m"
    t.integer  "height_m"
    t.string   "hair_color_m"
    t.string   "eye_color_m"
    t.string   "appearance_m"
    t.string   "bi_tendency_m"
    t.string   "sex_tend_m"
    t.boolean  "smoking_m"
    t.integer  "age_f"
    t.integer  "weight_f"
    t.integer  "height_f"
    t.string   "hair_color_f"
    t.string   "eye_color_f"
    t.string   "appearance_f"
    t.string   "bi_tendency_f"
    t.string   "sex_tend_f"
    t.boolean  "smoking_f"
    t.string   "region"
    t.string   "mobility"
    t.text     "about_us"
    t.text     "for_text"
    t.text     "like"
    t.text     "dislike"
    t.text     "looking_for"
    t.text     "to_do"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "approved",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["friend_id"], :name => "index_relationships_on_friend_id"
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "trusted",                             :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
