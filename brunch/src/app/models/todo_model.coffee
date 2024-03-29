class exports.Todo extends Backbone.Model

  defaults:
    content: 'empty todo...'
    done: false

  toggle: ->
    @save(done: not @get 'done')

  clear: ->
    @destroy()
    @view.remove()
  
  urlRoot: 'http://localhost:3000/todos/'
  