class Manage::TestCasesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @task = Task.find(params[:task_id])
    @test_case = @task.test_cases.build()
  end

  def create
    test_case_params = params.require(:test_case).permit(:file_name, :content, :memo)
    # フォームで編集したときの改行コードをCR+LF から LF にそろえる
    content = test_case_params[:content].gsub("\r\n", "\n")
    @task = Task.find(params[:task_id])
    @test_case = @task.test_cases.build(file_name: test_case_params[:file_name], memo: test_case_params[:memo])
    if @test_case.save
      file_path = "/data/tasks/#{@task.id}/#{@test_case.file_name}"
      File.open(file_path, 'wb') do |f|
        f.print(content)
      end
      redirect_to manage_task_test_cases_path(@task), notice: 'ファイルが追加されました!'
    else
      redirect_to manage_task_test_cases_path(@task), alert: 'ファイルの作成に失敗しました'
    end
  end

  def index
    @task = Task.find(params[:task_id])
    @test_cases = @task.test_cases.order(:file_name)
  end

  def show
  end

  def edit
    @test_case = TestCase.find(params[:id])
    @task = Task.find(params[:task_id])
  end

  def update
    @test_case = TestCase.find(params[:id])
    test_case_params = params.require(:test_case).permit(:file_name, :content, :memo)
    content = test_case_params[:content].gsub("\r\n", "\n")
    @task = Task.find(params[:task_id])
    if @test_case.update(file_name: test_case_params[:file_name], memo: test_case_params[:memo])
      file_path = "/data/tasks/#{@task.id}/#{@test_case.file_name}"
      File.open(file_path, 'wb') do |f|
        f.print(content)
      end
      redirect_to manage_task_test_cases_url(@task), notice: 'Task was successfully updated'
    else
      render url_for manage_task_test_case_url(@test_case)
    end
  end

  def destroy
    @test_case = TestCase.find(params[:id])
    @task = Task.find(params[:task_id])
    file_path = "/data/tasks/#{@task.id}/#{@test_case.file_name}"
    File.unlink(file_path)
    @test_case.destroy
    redirect_to manage_task_test_cases_path(@task), notice: 'ファイルの削除が完了しました'
  end

  def load_file
    @task = Task.find(params[:task_id])
    faileds = []
    file_path = "/data/tasks/#{@task.id}/*"
    Dir.glob(file_path).each do |file_name|
      name = File.basename(file_name)
      testcase = @task.test_cases.build(file_name: name)
      unless testcase.save
        faileds << name
      end
    end
    if faileds.empty?
      redirect_to manage_task_test_cases_path(@task), notice: '読み込みが完了しました'
    else
      redirect_to manage_task_test_cases_path(@task), alert: "読み込みに失敗したケースがありました\n#{faileds}"
    end
  end
end
