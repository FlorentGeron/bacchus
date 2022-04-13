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

ActiveRecord::Schema.define(version: 2022_04_12_150550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appellations", force: :cascade do |t|
    t.string "pays"
    t.string "region"
    t.string "nom"
    t.string "couleur"
    t.string "norme"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bouteilles", force: :cascade do |t|
    t.bigint "cuvee_id", null: false
    t.bigint "cave_id", null: false
    t.string "emplacement1"
    t.string "emplacement2"
    t.string "emplacement3"
    t.date "date_achat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "statut"
    t.float "prix"
    t.string "provenance"
    t.index ["cave_id"], name: "index_bouteilles_on_cave_id"
    t.index ["cuvee_id"], name: "index_bouteilles_on_cuvee_id"
  end

  create_table "caves", force: :cascade do |t|
    t.string "nom"
    t.string "localisation"
    t.integer "capacité"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_caves_on_user_id"
  end

  create_table "cuvees", force: :cascade do |t|
    t.bigint "appellation_id", null: false
    t.string "domaine"
    t.string "cuvee"
    t.date "annee"
    t.float "average_grade"
    t.float "prix_achat"
    t.float "prix_actuel"
    t.date "date_deg_min"
    t.date "date_deg_max"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["appellation_id"], name: "index_cuvees_on_appellation_id"
  end

  create_table "degustations", force: :cascade do |t|
    t.bigint "bouteille_id", null: false
    t.date "date_deg"
    t.string "plat"
    t.float "note_cuvee"
    t.text "commentaire"
    t.float "note_accord"
    t.text "commentaire_accord"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bouteille_id"], name: "index_degustations_on_bouteille_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bouteilles", "caves"
  add_foreign_key "bouteilles", "cuvees"
  add_foreign_key "caves", "users"
  add_foreign_key "cuvees", "appellations"
  add_foreign_key "degustations", "bouteilles"
end
