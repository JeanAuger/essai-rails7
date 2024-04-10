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

ActiveRecord::Schema[7.1].define(version: 2019_12_16_111317) do
  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", limit: 500
    t.integer "courses_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "user_id"
    t.integer "category_id"
    t.integer "subscriptions_count", default: 0, null: false
    t.float "average_rating", default: 0.0, null: false
    t.boolean "published", default: false
    t.boolean "approved", default: false
    t.string "language", default: "English", null: false
    t.integer "duration", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.text "short_description", limit: 500
    t.integer "lessons_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.string "level", default: "beginner", null: false
    t.index ["category_id"], name: "index_courses_on_category_id"
    t.index ["slug"], name: "index_courses_on_slug", unique: true
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", limit: 500
    t.text "video_url"
    t.integer "course_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug"
    t.integer "row_order"
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["slug"], name: "index_lessons_on_slug", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.integer "user_id"
    t.integer "course_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "price", default: 0, null: false
    t.index ["course_id"], name: "index_subscriptions_on_course_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'inet' for column 'current_sign_in_ip'

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "courses", "categories"
  add_foreign_key "courses", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "subscriptions", "courses"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_lessons", "lessons"
  add_foreign_key "user_lessons", "users"
end
