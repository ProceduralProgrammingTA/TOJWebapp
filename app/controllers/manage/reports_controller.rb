class Manage::ReportsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @student = Student.find(params[:student_id])
    # @submission = Submission.find(params[:id])
    @report = Report.find(params[:id])
  end

  def edit
    @student = Student.find(params[:student_id])
    @report = Report.find(params[:id])
  end

  def update
    @student = Student.find(params[:student_id])
    @report = Report.find(params[:id])
    report_params = params.require(:report).permit(:ta_comment)
    if @report.update(report_params)
      # redirect_to manage_student_path(@student), notice: 'TA comments was successfully updated'
      redirect_to manage_student_path(@student), notice: 'TA comments was successfully updated'
    else
      render url_for @student
    end
  end
end
