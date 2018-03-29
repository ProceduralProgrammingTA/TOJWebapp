class HomeController < ApplicationController
  before_action :authenticate_student!
  def index
    submissions = Submission.arel_table
    tasks = Task.arel_table
    current_student_submissions = submissions
      .where(submissions[:student_id].eq(current_student.id))
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
                 .select('MAX(submissions.created_at) AS submission_created_at')
      # この部分の挙動はSQLiteのMAX()の挙動に依存しているのでMySQLなどを使用する場合は注意
      # https://www.sqlite.org/lang_select.html#resultset
      # のSpecial processing occurs when ... min() or max() ... のあたり
      # MySQLでやるとMAX()のカラム以外は適当なrowが選択されるらしい
    # sql = 'select id from submissions as m where created_at = (select max(created_at) from submissions as s where m.task_id = s.task_id)'
    # submission_ids = Submission.find_by_sql(sql).map(&:id)

    # @tasks = Task.joins('LEFT OUTER JOIN submissions ON tasks.id = submissions.task_id')
    #              .where(["is_public = ? and submissions.id IN (?)", true, submission_ids])
    #              .select('tasks.*')
    #              .select('submissions.id AS submission_id')
    #              .select('submissions.ta_check AS submission_ta_check')
    #              .select('submissions.is_completed AS submission_is_completed')
    #              .select('submissions.status AS submission_status')
    #              .select('submissions.is_accepted AS submission_is_accepted')
    #              .order(:id)
    @report = Report.new
  end
end
