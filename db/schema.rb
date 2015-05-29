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

ActiveRecord::Schema.define(:version => 20150529064132) do

  create_table "admin_logs", :force => true do |t|
    t.integer  "admin_id"
    t.string   "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_name"
  end

  create_table "applicant_re_applications", :force => true do |t|
    t.integer  "applicant_id"
    t.integer  "applied_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicant_school_assignments", :force => true do |t|
    t.integer  "applicant_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicants", :force => true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "middlename"
    t.date     "bday"
    t.string   "gender"
    t.string   "highest_school_attainment"
    t.text     "address"
    t.string   "email_address"
    t.string   "contact"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position_id"
    t.string   "image_name"
    t.integer  "skipped_exam"
    t.integer  "consider"
  end

  create_table "applicants_interviewers", :id => false, :force => true do |t|
    t.integer "applicant_id"
    t.integer "interviewer_id"
  end

  create_table "departments", :force => true do |t|
    t.string   "department_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_position_assignments", :force => true do |t|
    t.integer  "position_id"
    t.integer  "exam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_score"
    t.integer  "passing_score"
  end

  create_table "grade_histories", :force => true do |t|
    t.integer  "applicant_re_applications_id"
    t.integer  "exam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
  end

  create_table "grades", :force => true do |t|
    t.string   "score"
    t.integer  "exam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "applicant_id"
    t.text     "remarks"
  end

  create_table "interviewers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position_title"
    t.string   "image_name"
    t.integer  "department_id"
  end

  create_table "positions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "applicant_id"
    t.integer  "interviewer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sched_start"
    t.datetime "sched_end"
    t.string   "grade"
    t.string   "remarks"
  end

  create_table "schools", :force => true do |t|
    t.string   "school_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "acronym"
  end

end
