(function() {
  $(document).ready(function() {
   
      search = function() {
          var input = $('#searchBox');
          var filter = input.val().toUpperCase();
          var list = $('#participantsList');
          
          list.children().each(function() {
          
                 if (this.innerHTML.toUpperCase().indexOf(filter) > -1) {
                     $(this).show();
                     $(this).prop('selected',true);
                 } else {
                     $(this).hide();
                 }
                 return;
             });
             //list.selectmenu('refresh', true);
      };
    
  });

  return;

}).call(this);
