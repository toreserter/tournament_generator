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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160524124020) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "home_team_score", limit: 4
    t.integer  "away_team_score", limit: 4
    t.integer  "home_team_id",    limit: 4
    t.integer  "away_team_id",    limit: 4
    t.integer  "tournament_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "round",           limit: 4
    t.string   "group",           limit: 255
  end

  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "team",           limit: 255
    t.integer  "tournament_id",  limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "played",         limit: 4,   default: 0
    t.integer  "score",          limit: 4,   default: 0
    t.integer  "win",            limit: 4,   default: 0
    t.integer  "draw",           limit: 4,   default: 0
    t.integer  "loss",           limit: 4,   default: 0
    t.integer  "goal_scored",    limit: 4,   default: 0
    t.integer  "goal_conceeded", limit: 4,   default: 0
    t.integer  "average",        limit: 4,   default: 0
    t.string   "group",          limit: 255
  end

  add_index "players", ["tournament_id"], name: "index_players_on_tournament_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "tournament_type", limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "state",           limit: 255
    t.text     "rules",           limit: 65535
    t.boolean  "is_private",      limit: 1,     default: false
  end

  create_table "user_tournaments", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "tournament_id", limit: 4
    t.string   "role",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_tournaments", ["tournament_id"], name: "index_user_tournaments_on_tournament_id", using: :btree
  add_index "user_tournaments", ["user_id"], name: "index_user_tournaments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
