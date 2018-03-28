class Manage::TasksController < ApplicationController
  before_action :authenticate_admin!
  def new
    @task = Task.new
    @sample_md ='
# 問題
## Hello World!
```sh
Hello World!
```
と出力するC言語のプログラムを書きなさい．

* 標準入力なしで出力する
* **最後に改行を入れることを忘れない**
* **必ず手元で動作確認をしてから提出すること**

プログラム例

```c
#include <stdio.h>
int main() {
  printf("Hello World!\n");
  return 0;
}
```
'
  end

  def create
    task_params = params.require(:task).permit(:title, :deadline, :description)
    @task = Task.new(task_params)

    filepath = "/data/tasks/#{@task.id}"
    FileUtils.mkdir_p(filepath) unless FileTest.exist?(filepath)
    test_script = filepath + '/test.sh'
    script_sample = '#!/bin/bash
studentname=$1
taskname=$2
output_limit=1000

shrink() {
  outfile=$1
  message=$2
  outsize="$(wc -c $outfile | awk \'{print $1}\')"
  head -c $output_limit $outfile
  echo
  [ $outsize -gt $output_limit ] && echo $message [$outsize bytes]
}

judge() {
  case=$1
  shift
  echo [case${case}]
  timeout 1 /$studentname/a.out "$@" < /$taskname/in$case > /$studentname/stdout$case 2> /$studentname/stderr$case
  exit_status=$?
  if [ $exit_status -eq 124 ] ; then
    echo TLE
  elif [ $exit_status -ne 0 ] ; then
    echo Runtime Error
    cat /$studentname/stderr$case
  elif diff -wB /$studentname/stdout$case /$taskname/out$case > /dev/null 2>&1 ; then
    echo OK
  else
    echo NG
    echo output:
    shrink /$studentname/stdout$case "++ Output is shrinked because it is too large. ++"
    echo expected:
    shrink /$taskname/out$case "++ Output is shrinked because it is too large. ++"
  fi
}

[ -f /$studentname/a.out ] && rm /$studentname/a.out
[ -f /$studentname/stdout1 ] && rm /$studentname/stdout*

timeout 10 gcc -lm -Wall /$studentname/submission.c -o /$studentname/a.out 2> /$studentname/compile_stderr

compile_status=$?
if [ $compile_status -ne 0 ] ; then
  echo Compile Error
  shrink /$studentname/compile_stderr "++ Error message from compiler is shrinked because it is too large. ++"
  [ $compile_status -eq 124 ] && echo ++ Compile time is too long. ++
  exit
elif [ "$(grep warning /$studentname/compile_stderr)" != "" ] ; then
  echo Compile Warning
  shrink /$studentname/compile_stderr "++ Error message from compiler is shrinked because it is too large. ++"
  exit
fi

for i in 1 2 3 4 ; do
  judge $i
done'

    File.open(test_script, 'w') do |f|
      f.print(script_sample)
    end
    test_case = @task.test_cases.build(:file_name => 'test.sh', :content => script_sample)
    test_case.save
    for i in (1..4) do
      input_file = @task.test_cases.build(:file_name => "in#{i}", :content => "input#{i}")
      input_file.save
      output_file = @task.test_cases.build(:file_name => "out#{i}", :content => "output#{i}")
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
    task_params = params.require(:task).permit(:title, :deadline, :description, :is_public)
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
    submissions = Submission.select(:id, 'MAX(created_at)', :status).group(:student_id)
      .where(task_id: task.id)
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
