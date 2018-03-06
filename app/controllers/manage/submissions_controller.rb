class Manage::SubmissionsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @student = Student.find(params[:student_id])
    @submissions = @student.submissions.group('task_id')
  end

  def show
    @student = Student.find(params[:student_id])
    @submission = Submission.find(params[:id])
  end

  def edit
    @student = Student.find(params[:student_id])
    @submission = Submission.find(params[:id])
    @current_task = Task.find(@submission.task_id)
    @task_title = @current_task.title
    @code = @submission.code.to_s
    @code.gsub('<', '&lt;')
    @code.gsub('>', '&gt;')
  end

  def update
    @student = Student.find(params[:student_id])
    @submission = Submission.find(params[:id])
    submission_params = params.require(:submission).permit(:ta_comment, :ta_check)
    if @submission.update(submission_params)
      redirect_to manage_student_path(@student), notice: 'TA comments was successfully updated'
    else
      render url_for @submission
    end
  end
end
