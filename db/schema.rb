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

ActiveRecord::Schema.define(version: 20151028145929) do

  create_table "matches", force: :cascade do |t|
    t.integer  "home_team_score", limit: 4
    t.integer  "away_team_score", limit: 4
    t.integer  "home_team_id",    limit: 4
    t.integer  "away_team_id",    limit: 4
    t.integer  "tournament_id",   limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "round",           limit: 4
  end

  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "team",           limit: 255
    t.integer  "tournament_id",  limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "played",         limit: 4
    t.integer  "score",          limit: 4
    t.integer  "win",            limit: 4
    t.integer  "draw",           limit: 4
    t.integer  "loss",           limit: 4
    t.integer  "goal_scored",    limit: 4
    t.integer  "goal_conceeded", limit: 4
    t.integer  "average",        limit: 4
  end

  add_index "players", ["tournament_id"], name: "index_players_on_tournament_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "tournament_type", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "state",           limit: 255
  end

end
