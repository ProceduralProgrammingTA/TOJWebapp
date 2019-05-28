class Manage::TasksController < ApplicationController
  before_action :authenticate_admin!
  def new
    @task = Task.new
    sample_file_path = Rails.root.join('file_templates', 'task_sample.md')
    @sample_md = ''
    File.open(sample_file_path, 'r') do |f|
      @sample_md = f.read()
    end
  end

  def create
    task_params = params.require(:task).permit(:title, :deadline, :description, :is_scoring)
    @task = Task.create(task_params)

    filepath = "/data/tasks/#{@task.id}"
    FileUtils.mkdir_p(filepath) unless FileTest.exist?(filepath)
    test_script = filepath + '/test.sh'
    script_template = Rails.root.join('file_templates', 'test.sh')

    FileUtils.cp(script_template, test_script)
    test_case = @task.test_cases.build(file_name: 'test.sh')
    test_case.save
    for i in (1..4) do
      input_file = @task.test_cases.build(file_name: "in#{i}")
      input_file.save
      output_file = @task.test_cases.build(file_name: "out#{i}")
      output_file.save
      File.open(filepath + "/in#{i}", 'w') do |f|
        f.print("input#{i}")
      end
      File.open(filepath + "/out#{i}", 'w') do |f|
        f.print("output#{i}")
      end
    end
    if @task.save
      redirect_to url_for(@tasks), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def index
    @tasks = Task.all
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    task_params = params.require(:task).permit(:title, :deadline, :description, :is_public, :is_scoring)
    if @task.update(task_params)
      redirect_to manage_task_url(@task), notice: 'Task was successfully updated'
    else
      render url_for manage_task_url(@task)
    end
  end

  def togglePublic
    task = Task.select(:id, :is_public).find(params[:task_id])
    task.is_public = !task.is_public
    if task.save
      render json: task
    end
  end

  def rejudge
    task = Task.find(params[:task_id])
    sql = "select max(created_at) from submissions group by student_id, task_id having task_id = #{task.id}"
    submission_time = Submission.find_by_sql(sql).map do |s|
      s.attributes["max(created_at)"]
    end

    submissions = Submission.where(created_at: submission_time)
    submissions.each { |sub| sub.status = 'Queued' }
    Submission.transaction { submissions.each(&:save) }
    task.last_rejudge = DateTime.now
    if task.save
      render json: task
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to manage_tasks_path(@task), notice: 'Task was successfully destroyed'
  end

  def show
    @task = Task.find(params[:id])
    @students = Student.all
    @submissions = @task.submissions.group('student_id')
    @student_submissions = Student.joins('left outer join submissions on submissions.student_id = students.id').select('students.*, submissions.*').group('students.id')
  end
end
