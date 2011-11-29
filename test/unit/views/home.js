(function() {
  $(document).ready(function() {
    module('home view', {
      setup: function() {
        window.location.hash = "home";
        app.initialize();
        return Backbone.history.loadUrl();
      },
      teardown: function() {
        return localStorage.clear();
      }
    });
    return test('render subviews', function() {
      var el;
      expect(3);
      el = app.views.home.render().el;
      equals($(el).find('#new-todo-view').length, 1);
      equals($(el).find('#todos-view').length, 1);
      return equals($(el).find('#stats-view').length, 1);
    });
  });
}).call(this);
