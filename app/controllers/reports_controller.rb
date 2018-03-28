require 'kconv'
class ReportsController < ApplicationController
  before_action :authenticate_student!
  def create
    reports_param = params.require(:report).permit(:task_title, :file, :file_name, :student_comment)
    @report = current_student.reports.build(reports_param)
    file = reports_param[:file]
    file_name = "#{current_student.name}.pdf"
    @report.file_name = file.original_filename
    result = upload_pdf(file, @report.task_title, file_name)
    last_report = current_student.reports.where(:task_title => reports_param[:task_title]).order('created_at desc').first
    unless last_report.nil? || last_report.ta_comment.blank?
      @report.ta_comment = last_report.ta_comment
    end

    if result == 'success' && @report.save
      redirect_to root_path, notice: 'レポートの提出に成功しました'
    else
      delete_pdf(file.path, @report.task_title) rescue Errno::ENOENT
      redirect_to root_path, notice: result
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    report_params = params.require(:report).permit(:student_comment)
    if @report.update(report_params)
      redirect_to root_path, notice: 'コメント投稿が成功しました'
    else
      render url_for root_path
    end
  end

  private
  def upload_pdf(file_object, task_title, file_name)
    file_path = "/data/#{current_student.name}/reports/#{task_title}"
    FileUtils.mkdir_p(file_path) unless FileTest.exist?(file_path)
    perms = ['.pdf']
    if !perms.include?(File.extname(file_object.path).downcase)
      result = 'アップロードできるのはpdfファイルのみです．'
    else
      File.open(file_path + "/#{file_name.toutf8}", 'wb') do |f|
        f.write(file_object.read)
      end
      result = 'success'
    end
    return result
  end

  def delete_pdf(file_name, task_title)
    File.unlink "/data/#{current_student.name}/reports/#{task_title}/#{file_name.toutf8}"
  end
end
