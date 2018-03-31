class HomeController < ApplicationController
  before_action :authenticate_student!
  def index
    submissions = Submission.arel_table
    tasks = Task.arel_table

    sql = "select max(created_at) from submissions group by student_id, task_id having student_id = #{current_student.id}"
    submission_time = Submission.find_by_sql(sql).map do |s|
      s.attributes["max(created_at)"]
    end

    current_student_submissions = submissions
      .where(submissions[:created_at].in(submission_time))
      .project(Arel.star)
      .as('submissions')
    join_conds = tasks.join(current_student_submissions, Arel::Nodes::OuterJoin)
      .on(current_student_submissions[:task_id].eq(tasks[:id])).join_sources
    @tasks = Task.joins(join_conds)
                 .where(is_public: true)
                 .order(:id).group(:id)
                 .select('tasks.*')
                 .select('submissions.id AS submission_id')
                 .select('submissions.ta_check AS submission_ta_check')
                 .select('submissions.is_completed AS submission_is_completed')
                 .select('submissions.status AS submission_status')
                 .select('submissions.is_accepted AS submission_is_accepted')
                 .select('submissions.created_at AS submission_created_at')
      # 2018/Mar/31 この部分でMAXを使わなくてもいいように修正
      # この部分の挙動はSQLiteのMAX()の挙動に依存しているのでMySQLなどを使用する場合は注意
      # https://www.sqlite.org/lang_select.html#resultset
      # のSpecial processing occurs when ... min() or max() ... のあたり
      # MySQLでやるとMAX()のカラム以外は適当なrowが選択されるらしい
    # なぜかここで取得するcreated_atはTimezoneがUTCになるので、Tokyoに合わせる
    @tasks.map { |task| task.submission_created_at = task.submission_created_at.in_time_zone('Tokyo') }
    @report = Report.new
  end
end
