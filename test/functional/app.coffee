$(document).ready( ->

  module('functional app testing',
    setup: ->
      window.location.hash = "home"
      app.initialize()
      Backbone.history.loadUrl()
    teardown: ->
      localStorage.clear()
  )

  test('Add new todo', ->
    expect 4
    # insert data and press enter
    $('#new-todo').val 'bring out the garbage'
    testHelpers.keydown $.ui.keyCode.ENTER, '#new-todo'
    todo = app.collections.todos.at(0)

    # check for model attributes
    equals todo.get('content'), 'bring out the garbage'
    equals todo.get('done'), false

    # check for todo entry in dom
    todoDOMEntry = $('#todos > li')
    equals todoDOMEntry.find('.todo-content').html(), 'bring out the garbage'
    equals todoDOMEntry.find('.check').is(':checked'), false
  )

  test("Add empty todo", ->
    expect 4
    # press enter on empty input field
    $('#new-todo').val ''
    testHelpers.keydown $.ui.keyCode.ENTER, '#new-todo'
    todo = app.collections.todos.at(0)

    # check for model attributes
    equals todo.get('content'), 'empty todo...'
    equals todo.get('done'), false

    # check for todo entry in dom
    todoDOMEntry = $('#todos > li')
    equals todoDOMEntry.find('.todo-content').html(), 'empty todo...'
    equals todoDOMEntry.find('.check').is(':checked'), false
  )

  test("Update todo's content", ->
    expect 3
    testHelpers.createTodo()
    todoDOMEntry = $('#todos > li')
    # double click and check if edit mode is active
    # TODO check for editing should be moved to unit tests of the corresponding view
    todoDOMEntry.find('.todo-content').trigger 'dblclick'
    equals todoDOMEntry.hasClass('editing'), true

    # update content in todo and save it
    todoDOMEntry.find('.todo-input').val 'cleanup dirt from torn garbage bag'
    testHelpers.keydown $.ui.keyCode.ENTER, '.todo-input'

    # check for model content
    equals app.collections.todos.at(0).get('content'), 'cleanup dirt from torn garbage bag'

    # check for todo entry in dom
    equals todoDOMEntry.find('.todo-content').html(), 'cleanup dirt from torn garbage bag'
  )

  test("Update todo's status", ->
    expect 2
    testHelpers.createTodo()
    todoDOMEntry = $('#todos > li')

    # click on todo's checkbox and check if model changed
    todoDOMEntry.find('.check').trigger('click')
    equals app.collections.todos.at(0).get('done'), true
    todoDOMEntry.find('.check').trigger('click')
    equals app.collections.todos.at(0).get('done'), false
  )

  test("Delete todo", ->
    expect 2
    testHelpers.createTodo()
    $('#todos > li').find('.todo-destroy').trigger('click')
    equals app.collections.todos.length, 0
    equals $('#todos').html(), ''
  )

  test("Check all stats (total, done and remaining)", ->
    expect 5
    # create 2 todos and mark one as done
    testHelpers.createTodo()
    testHelpers.createTodo('answer support request')
    $('#todos > li:first').find('.check').trigger('click')

    # check for collection stats
    equals app.collections.todos.length, 2
    equals app.collections.todos.done().length, 1
    equals app.collections.todos.remaining().length, 1
    equals $('.todo-count > .number').html(), '1'
    equals $('.todo-clear').find('.number-done').html(), '1'
  )

  test("Clear todos", ->
    expect 2
    testHelpers.createTodo()

    # mark todo as done and clear all todos
    $('#todos > li').find('.check').trigger('click')
    $('.todo-clear > a').trigger('click')
    equals app.collections.todos.length, 0
    equals $('#todos').html(), ''
  )
)
