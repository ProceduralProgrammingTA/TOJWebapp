class Manage::ManageController < ApplicationController
  before_action :authenticate_admin!
  def index
  end

  def export_tacheck
    sql =  "select grades.student_id as student_id, grades.task_id as task_id, name as student_name, grades.task_title as task_title, grades.ta_check as ta_check
            from students
            inner join
            (
              select grades.student_id as student_id, grades.task_id as task_id, title as task_title, grades.ta_check as ta_check
              from tasks
              inner join
              (
                select student_id, task_id, max(ta_check) as ta_check from submissions
                group by student_id, task_id
              ) grades
              on tasks.id = grades.task_id
            ) grades
            on students.id = grades.student_id"

    table = Submission.find_by_sql(sql)

    student_num = table.map {|x| x.student_id }.max + 1
    student_name = []
    task_num = table.map {|x| x.task_id }.max + 1
    task_title = []

    ta_checks = Array.new(student_num) { Array.new(task_num, 0) }
    table.each do |s|
      student_name[s.student_id] = s.student_name
      task_title[s.task_id] = s.task_title
      ta_checks[s.student_id][s.task_id] = s.ta_check
    end

    task_ta_check_max = ta_checks.transpose.map &:max

    require 'csv'
    csv_data = CSV.generate do |csv|
      csv << [ nil ] + task_title.select.with_index { |title, idx| task_ta_check_max[idx] > 0 }
      student_num.times do |i|
        if ta_checks[i].max > 0
          csv << [ student_name[i] ] + ta_checks[i].select.with_index { |val, idx| task_ta_check_max[idx] > 0 }
        end
      end
    end

    send_data csv_data, filename: 'exported_tacheck.csv', type: 'text/csv'
  end

  def export_ac
    sql =  "select subs.student_id as student_id, subs.task_id as task_id, name as student_name, subs.task_title as task_title
            from students
            inner join
            (
              select subs.student_id as student_id, subs.task_id as task_id, title as task_title
              from tasks
              inner join
              (
                select student_id, task_id from submissions
                where is_accepted = true
                group by student_id, task_id
              ) subs
              on tasks.id = subs.task_id
            ) subs
            on students.id = subs.student_id"

    table = Submission.find_by_sql(sql)

    student_num = table.map {|x| x.student_id }.max + 1
    student_name = []
    task_num = table.map {|x| x.task_id }.max + 1
    task_title = []

    is_accepted = Array.new(student_num) { Array.new(task_num, false) }
    table.each do |s|
      student_name[s.student_id] = s.student_name
      task_title[s.task_id] = s.task_title
      is_accepted[s.student_id][s.task_id] = true
    end

    task_has_accepted = is_accepted.transpose.map &:any?

    require 'csv'
    csv_data = CSV.generate do |csv|
      csv << [ nil ] + task_title.select.with_index { |title, idx| task_has_accepted[idx] }
      student_num.times do |i|
        if is_accepted[i].any?
          csv << [ student_name[i] ] + is_accepted[i].select.with_index { |val, idx| task_has_accepted[idx] }
        end
      end
    end

    send_data csv_data, filename: 'exported_ac.csv', type: 'text/csv'
  end
  def import_students
    seed_file = params[:file]
    created_students = []
    all_cnt = 0
    require 'csv'
    CSV.foreach(seed_file.path) do |row|
      name = row[0]
      password = row[1]
      student = Student.new(name: name, password: password)
      all_cnt += 1
      if student.save
        created_students << name
      end
    end
    redirect_to manage_students_path, notice: "学生の作成が完了しました (#{created_students.length}/#{all_cnt})"
  end
end
