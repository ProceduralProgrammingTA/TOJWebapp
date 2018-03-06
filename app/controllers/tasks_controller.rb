class TasksController < ApplicationController
  before_action :authenticate_student!
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
    if !@task.is_public and !current_student.name.include?('test.t.')
      raise ActionController::RoutingError, with: :rescue_404
    end
    @submission = current_student.submissions.where(:task_id => @task.id).order('created_at DESC').first
  end
end
