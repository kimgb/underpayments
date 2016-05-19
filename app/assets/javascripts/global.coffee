$("a.manipulator").on "click", (e) ->
  $(e.target.dataset.hide).slideUp(800)
  $(e.target.dataset.show).delay(800).slideDown(800)
