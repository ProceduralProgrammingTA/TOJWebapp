
$.turbo.use 'turbolinks:render', 'turbolinks:request-start'

###
statusReload = (el, taskId, submissionId) ->
  $.get "/toj/tasks/#{taskId}/submissions/#{submissionId}/status.json", {}, (data) ->
    el.text("#{data.status}")
    if !data.is_completed
      setTimeout ->
        statusReload el, taskId, submissionId
      , 1000

$ ->
  $('.container').find('.submission-status').each ->
    el = $(@)
    taskId = el.data 'taskid'
    submissionId = el.data 'submissionid'
    statusReload el, taskId, submissionId
###
