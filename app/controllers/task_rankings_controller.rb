class TaskRankingsController < ApplicationController
  before_action :authenticate_student!
  def show
    @task = Task.find(params[:id])
    if !@task.is_public and !current_student.name.include?('test.t.')
      raise ActionController::RoutingError, with: :rescue_404
    end

    submissions = Submission.arel_table
    students = Student.arel_table

    # その task に対する各学生の最初の AC 提出を取得
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

    @students.map { |student| student.submission_created_at = student.submission_created_at&.in_time_zone('Tokyo') }
  end
end
