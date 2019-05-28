class TaskRankingsController < ApplicationController
  before_action :authenticate_student!
  def show
    @task = Task.find(params[:id])
    if !@task.is_public and !current_student.name.include?('test.t.')
      raise ActionController::RoutingError, with: :rescue_404
    end

    submissions = Submission.arel_table
    students = Student.arel_table

    unless @task.is_scoring then
      # その task に対する各学生の最初の AC 提出の時刻を取得
      first_accepted_submissions = submissions
        .where(submissions[:task_id].eq(@task.id))
        .where(submissions[:is_accepted].eq(true))
        .project(Arel.sql(%|
          submissions.student_id as student_id,
          MIN(created_at) as submission_time
        |))
        .group("submissions.student_id").as("first_accepted_submissions")

      join_conds = students.join(first_accepted_submissions, Arel::Nodes::InnerJoin)
        .on(first_accepted_submissions[:student_id].eq(students[:id]))
        .join_sources

      @students = Student.joins(join_conds)
        .order('first_accepted_submissions.submission_time')
        .select('students.*')
        .select('first_accepted_submissions.submission_time AS submission_created_at')
    else
      # その task に対する各学生のスコアが最大の提出のうち最初の提出を取得

      sql =  "select * from students
              inner join
              (
                select student_id, score as submission_score, min(created_at) as submission_created_at
                from submissions
                where
                  task_id = #{@task.id} and is_accepted = true and score is not NULL
                  and
                  (student_id, score)
                  in
                  (
                    select student_id, max(score) as score from submissions
                    where task_id = #{@task.id} and is_accepted = true and score is not NULL
                    group by student_id
                  )
                group by student_id, score
              ) best_submissions
              on students.id = best_submissions.student_id
              order by submission_score desc, submission_created_at asc;"

      @students = Student.find_by_sql(sql)
    end

    @students.map { |student| student.submission_created_at = student.submission_created_at&.in_time_zone('Tokyo') }
  end
end
