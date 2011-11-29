$(document).ready( ->
  module('todo view',
    setup: ->
      TodoView = require('views/todo_view').TodoView

      window.location.hash = "home"
      app.initialize()
      Backbone.history.loadUrl()
      @todo = app.collections.todos.create()
      @view = new TodoView(model: @todo)
    teardown: ->
      localStorage.clear()
  )

  test('initialize view', ->
    expect 2
    ok @view.model._callbacks.change
    ok @view.model.view
  )

  test('render view', ->
    expect 2
    el = @view.render().el
    equals $(el).find('.todo-input').length, 1
    ok $(el).find('.todo-input').data("events").blur
  )
)
