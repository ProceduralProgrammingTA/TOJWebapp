# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".change-public").on "click", (e) ->
    e.preventDefault()
    el = $(@)
    id = el.data("id")
    $.post "/toj/manage/tasks/#{id}/toggle_public", {}, (data) ->
      el.text(if data.is_public then "公開" else "非公開")

  $(".rejudge-button").on "click", (e) ->
    e.preventDefault()
    el = $(@)
    id = el.data("id")
    $("#rejudge-modal-task-name").text el.parent().parent().children().first().text()
    $("#rejudge-execute-button").data "id", id
    $("#rejudge-modal").modal("show")

  $("#rejudge-execute-button").on "click", (e) ->
    e.preventDefault()
    id = $(@).data "id"
    $.post "/toj/manage/tasks/#{id}/rejudge"
