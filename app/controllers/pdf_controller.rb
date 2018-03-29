class PdfController < ApplicationController
  def show
    report = Report.find(params[:report_id])
    if admin_signed_in?
      student_name = report.student.name
    elsif student_signed_in? && report.student.name == current_student.name
      student_name = current_student.name
    end
    if student_name.nil? || report.student.name != student_name
      raise ActionController::RoutingError.new 'Not Found'
    end
    task_title = report.task_title
    file_name = "#{student_name}.pdf"
    file_path = "/data/#{student_name}/reports/#{task_title}/"
    send_file(file_path+file_name, filename: file_name, type: 'application/pdf', disposition: 'inline', length: File::size(file_path+file_name))
  end
end
