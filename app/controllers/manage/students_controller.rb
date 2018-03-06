class Manage::StudentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
    @submissions = @student.submissions.group("task_id")
    @reports = @student.reports.group('task_title')
  end

  def new
    @student = Student.new
  end

  def create
    student_params = params.require(:student).permit(:name, :password)
    @student = Student.new(student_params)
    if @student.save
      redirect_to manage_students_path, notice: '学生の作成が完了しました'
    else
      render :new
    end
  end

  def edit
    @student = Student.find(params[:id])
    # student_params = params.require(:student).permit(:name, :password)
    if @student.update(:name => params[:name], :password  => params[:password])
      redirect_to @student, notice: '編集が完了しました'
    else
      render :edit
    end
  end

  def update
    @student = Student.find(params[:id])
    student_params = params.require(:student).permit(:password)
    if @student.update(student_params)
      redirect_to manage_students_path, notice: '学生情報の編集が完了しました'
    else
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to manage_students_url, notice: '削除が完了しました'
  end
end
