class SubmissionsController < ApplicationController
  before_action :authenticate_student!
  def create
    submission_param = params.require(:submission).permit(:code, :ta_comment, :ta_check)

    @task = Task.find(params[:task_id])

    if submission_param[:code].nil? then
      redirect_to task_path(@task), alert: 'ファイルが選択されていません．'
      return
    end

    file_lim = 60000

    if submission_param[:code].size > file_lim then
      redirect_to task_path(@task), alert: 'ファイルの容量が大きすぎます (%d Byte)．' % submission_param[:code].size
      return
    end

    upload_file = submission_param[:code].read.force_encoding('utf-8')
    unless upload_file.valid_encoding? then
      redirect_to task_path(@task), alert: 'ファイルの文字コードは UTF-8 で提出してください．'
      return
    end

    @submission = @task.submissions.build(submission_param)
    current_student.submissions << @submission
    @submission.code = upload_file

    filepath = "/data/submissions/#{@submission.id}"
    FileUtils.mkdir_p(filepath) unless FileTest.exist?(filepath)

    filename = filepath + '/submission.c'
    File.open(filename, 'w') do |f|
      f.puts(@submission.code)
    end

    @submission.status = 'Queued'
    @submission.is_accepted = @submission.status == 'AC'

    if @submission.save
      redirect_to task_submission_path(@task, @submission), notice: 'Your submission was Completed!'
    else
      render :show
    end
  end

  def show
    @submission = Submission.find(params[:id])
    unless @submission.student_id == current_student.id then
      raise ActionController::RoutingError, with: :rescue_404
    end
    @current_task = Task.find(@submission.task_id)
    @task_title = @current_task.title
    @code = @submission.code.to_s
    @code.gsub('<', '&lt;')
    @code.gsub('>', '&gt;')
  end

  def status
    @submission = Submission.select('id, task_id, status, is_accepted, is_completed').find(params[:id])
    render json: @submission
  end

  def index
    @task = Task.find(params[:task_id])
    @submissions = @task.submissions.where(:student_id => current_student.id).order('created_at desc')
  end
end
