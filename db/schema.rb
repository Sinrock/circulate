# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_08_203157) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :adjustment_kind, [
    "fine",
    "membership",
    "donation",
    "payment",
  ]
  create_enum :adjustment_source, [
    "cash",
    "square",
    "forgiveness",
  ]
  create_enum :notification_status, [
    "pending",
    "sent",
    "bounced",
    "error",
  ]

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "adjustments", force: :cascade do |t|
    t.string "adjustable_type"
    t.bigint "adjustable_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.bigint "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "payment_source", enum_name: "adjustment_source"
    t.string "square_transaction_id"
    t.enum "kind", null: false, enum_name: "adjustment_kind"
    t.index ["adjustable_type", "adjustable_id"], name: "index_adjustments_on_adjustable_type_and_adjustable_id"
    t.index ["member_id"], name: "index_adjustments_on_member_id"
  end

  create_table "agreement_acceptances", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_agreement_acceptances_on_member_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "borrow_policies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "duration", default: 7, null: false
    t.integer "fine_cents", default: 0, null: false
    t.string "fine_currency", default: "USD", null: false
    t.integer "fine_period", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "uniquely_numbered", default: true, null: false
    t.string "code", null: false
    t.string "description"
    t.boolean "default", default: false, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", null: false
    t.string "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
  end

  create_table "gift_memberships", force: :cascade do |t|
    t.string "purchaser_email", null: false
    t.string "purchaser_name", null: false
    t.integer "amount_cents", null: false
    t.string "code", null: false
    t.bigint "membership_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "recipient_name"
    t.index ["membership_id"], name: "index_gift_memberships_on_membership_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "size"
    t.string "brand"
    t.string "model"
    t.string "serial"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number", null: false
    t.integer "status", default: 1, null: false
    t.bigint "borrow_policy_id", null: false
    t.string "strength"
    t.integer "quantity"
    t.string "checkout_notice"
    t.index ["borrow_policy_id"], name: "index_items_on_borrow_policy_id"
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "member_id"
    t.datetime "due_at"
    t.datetime "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "uniquely_numbered", null: false
    t.integer "renewal_count", default: 0, null: false
    t.bigint "initial_loan_id"
    t.index ["ended_at"], name: "index_loans_on_ended_at"
    t.index ["initial_loan_id"], name: "index_loans_on_initial_loan_id"
    t.index ["item_id"], name: "index_active_numbered_loans_on_item_id", unique: true, where: "((ended_at IS NULL) AND (uniquely_numbered = true))"
    t.index ["item_id"], name: "index_loans_on_item_id"
    t.index ["member_id"], name: "index_loans_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "preferred_name"
    t.string "email", null: false
    t.string "phone_number", null: false
    t.integer "pronoun"
    t.string "custom_pronoun"
    t.text "notes"
    t.integer "id_kind"
    t.string "other_id_kind"
    t.boolean "address_verified"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.string "postal_code"
    t.boolean "reminders_via_email", default: false, null: false
    t.boolean "reminders_via_text", default: false, null: false
    t.boolean "receive_newsletter", default: false, null: false
    t.boolean "volunteer_interest", default: false, null: false
    t.string "desires"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "region"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.datetime "started_on", precision: 6, null: false
    t.datetime "ended_on", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_memberships_on_member_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "address", null: false
    t.string "action", null: false
    t.bigint "member_id"
    t.uuid "uuid", null: false
    t.enum "status", default: "pending", null: false, enum_name: "notification_status"
    t.string "subject", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_notifications_on_member_id"
    t.index ["uuid"], name: "index_notifications_on_uuid"
  end

  create_table "short_links", force: :cascade do |t|
    t.string "url", null: false
    t.string "slug", null: false
    t.integer "views_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id", "tag_id"], name: "index_taggings_on_item_id_and_tag_id"
    t.index ["item_id"], name: "index_taggings_on_item_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "taggings_count", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adjustments", "members"
  add_foreign_key "agreement_acceptances", "members"
  add_foreign_key "gift_memberships", "memberships"
  add_foreign_key "loans", "items"
  add_foreign_key "loans", "loans", column: "initial_loan_id"
  add_foreign_key "loans", "members"
  add_foreign_key "memberships", "members"
  add_foreign_key "notifications", "members"
  add_foreign_key "taggings", "items"
  add_foreign_key "taggings", "tags"

  create_view "loan_summaries", sql_definition: <<-SQL
      SELECT loans.item_id,
      loans.member_id,
      COALESCE(loans.initial_loan_id, loans.id) AS initial_loan_id,
      max(loans.id) AS latest_loan_id,
      min(loans.created_at) AS created_at,
      max(loans.due_at) AS due_at,
          CASE
              WHEN (count(loans.ended_at) = count(loans.id)) THEN max(loans.ended_at)
              ELSE NULL::timestamp without time zone
          END AS ended_at,
      max(loans.renewal_count) AS renewal_count
     FROM loans
    GROUP BY loans.item_id, loans.member_id, COALESCE(loans.initial_loan_id, loans.id);
  SQL
  create_view "monthly_activities", sql_definition: <<-SQL
      WITH dates AS (
           SELECT min(date_trunc('month'::text, loans.created_at)) AS startm,
              max(date_trunc('month'::text, loans.created_at)) AS endm
             FROM loans
          ), months AS (
           SELECT generate_series(dates.startm, dates.endm, '1 mon'::interval) AS month
             FROM dates
          )
   SELECT (date_part('year'::text, months.month))::integer AS year,
      (date_part('month'::text, months.month))::integer AS month,
      count(DISTINCT l.id) AS loans_count,
      count(DISTINCT l.member_id) AS active_members_count,
      count(DISTINCT m.id) FILTER (WHERE (m.status = 0)) AS pending_members_count,
      count(DISTINCT m.id) FILTER (WHERE (m.status = 1)) AS new_members_count
     FROM ((months
       LEFT JOIN loans l ON ((date_trunc('month'::text, l.created_at) = months.month)))
       LEFT JOIN members m ON ((date_trunc('month'::text, m.created_at) = months.month)))
    GROUP BY months.month
    ORDER BY months.month;
  SQL
  create_view "monthly_adjustments", sql_definition: <<-SQL
      SELECT (date_part('year'::text, adjustments.created_at))::integer AS year,
      (date_part('month'::text, adjustments.created_at))::integer AS month,
      count(*) FILTER (WHERE (adjustments.kind = 'membership'::adjustment_kind)) AS membership_count,
      count(*) FILTER (WHERE (adjustments.kind = 'fine'::adjustment_kind)) AS fine_count,
      sum((- adjustments.amount_cents)) FILTER (WHERE (adjustments.kind = 'fine'::adjustment_kind)) AS fine_total_cents,
      sum((- adjustments.amount_cents)) FILTER (WHERE (adjustments.kind = 'membership'::adjustment_kind)) AS membership_total_cents,
      sum(adjustments.amount_cents) FILTER (WHERE (adjustments.kind = 'payment'::adjustment_kind)) AS payment_total_cents,
      sum(adjustments.amount_cents) FILTER (WHERE ((adjustments.kind = 'payment'::adjustment_kind) AND (adjustments.payment_source = 'square'::adjustment_source))) AS square_total_cents,
      sum(adjustments.amount_cents) FILTER (WHERE ((adjustments.kind = 'payment'::adjustment_kind) AND (adjustments.payment_source = 'cash'::adjustment_source))) AS cash_total_cents,
      sum(adjustments.amount_cents) FILTER (WHERE ((adjustments.kind = 'payment'::adjustment_kind) AND (adjustments.payment_source = 'forgiveness'::adjustment_source))) AS forgiveness_total_cents
     FROM adjustments
    GROUP BY ((date_part('year'::text, adjustments.created_at))::integer), ((date_part('month'::text, adjustments.created_at))::integer);
  SQL
end
