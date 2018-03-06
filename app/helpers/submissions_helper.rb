module SubmissionsHelper
  def show_status_td(submission)
    s = if submission.status.nil?
      submission.is_accepted ? 'AC' : 'WA'
    else
      submission.status
    end
    c = submission.is_completed ? '' : 'submission-status'
    "<td class=\"#{c}\" data-submissionid=\"#{submission.id}\" data-taskid=\"#{submission.task_id}\">#{s}</td>".html_safe
  end
end
