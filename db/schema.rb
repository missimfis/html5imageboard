# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_29_182248) do
  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["title"], name: "index_boards_on_title", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.integer "board_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "svg"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["board_id"], name: "index_posts_on_board_id"
    t.index ["created_at"], name: "index_posts_on_created_at"
  end
end
