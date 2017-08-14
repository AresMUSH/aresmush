$(function() {

  var mark = function() {

    // Read the keyword
    var keyword = $("input[name='keyword']").val();

    
    // Remove previous marked elements and mark
    // the new keyword inside the context
    $("#help").unmark({
      done: function() {
        $("#help").mark(keyword, {});
      }
    });
  };

  $("input[name='keyword']").on("input", mark);
  mark();
});
