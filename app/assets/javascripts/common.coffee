
$.turbo.use 'turbolinks:render', 'turbolinks:request-start'

$ ->
  loadMathJax()
  $(document).on 'turbolinks:load', loadMathJax

loadMathJax = ->
  window.MathJax = null
  $.getScript "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML", ->
    MathJax.Hub.Config
      tex2jax: { inlineMath: [['$','$']] }


###
statusReload = (el, taskId, submissionId) ->
  $.get "/tasks/#{taskId}/submissions/#{submissionId}/status.json", {}, (data) ->
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
