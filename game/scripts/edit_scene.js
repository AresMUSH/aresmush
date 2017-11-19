(function() {
  $(document).ready(function() {
   
      addChar = function() {
          var list = $('#participantsList');
          var names = $('#participants');
          names.val(names.val() + ' ' + list.val());
      };
      
      addScene = function() {
          var list = $('#scenesList');
          var names = $('#relatedScenes');
          names.val(names.val() + ' ' + list.val());
      };
      
      searchScenes = function() {
          var input = $('#searchScenesBox');
          var filter = input.val().toUpperCase();
          var list = $('#scenesList');
          
          list.children().each(function() {
          
                 if (this.innerHTML.toUpperCase().indexOf(filter) > -1) {
                     $(this).show();
                     $(this).prop('selected',true);
                 } else {
                     $(this).hide();
                     $(this).prop('selected',false);
                 }
                 return;
             });
         };
             
      searchChars = function() {
          var input = $('#searchCharsBox');
          var filter = input.val().toUpperCase();
          var list = $('#participantsList');
          
          list.children().each(function() {
          
                 if (this.innerHTML.toUpperCase().startsWith(filter)) {
                     $(this).show();
                     $(this).prop('selected',true);
                 } else {
                     $(this).hide();
                     $(this).prop('selected',false);
                 }
                 return;
             });
             //list.selectmenu('refresh', true);
      };
    
  });

  return;

}).call(this);
