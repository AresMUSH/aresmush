(function() {
  $(document).ready(function() {
      $('a#hide-file-upload').hide();
      $('a#show-file-upload').show();
      $('#file-upload-frame').hide();
   
     
      deleteProfile = function(deleteButtonObj) {
          var profile = deleteButtonObj.parent().parent().parent();
          profile.remove();
      };
      
      deleteRelation = function(deleteRelationObj) { 
          var relation = deleteRelationObj.parent().parent().parent();
          relation.remove();
      };
      
      deleteHook = function(deleteHookObj) { 
          var hook = deleteHookObj.parent().parent().parent();
          hook.remove();
      };
      
    $('a#add-profile').click(function() {
        var profileCount = $("#profile-container").children().length;
        var newDiv = $("#new-profile-field").clone();
        newDiv.appendTo("#profile-container");
        var input = newDiv.find("input");
        input.attr('name', 'profiletitle-' + profileCount);
        var textArea = newDiv.find("textarea")
        textArea.attr('name', 'profile-' + profileCount);
        newDiv.css('display', 'block');
        var deleteButton = newDiv.find("#delete-profile");
        deleteButton.click(function() {
            deleteProfile($(this));
        });
    });
    
    $('a#delete-profile').click(function() {
        deleteProfile($(this));
    });
    
    $('a#add-relation').click(function() {
        var relationCount = $("#relation-container").children().length;
        var newDiv = $("#new-relation-field").clone();
        newDiv.appendTo("#relation-container");
        var relationName = newDiv.find("input[name=relationname-new]");
        relationName.attr('name', 'relationname-new' + relationCount);
        var relationCat = newDiv.find("input[name=relationcat-new]");
        relationCat.attr('name', 'relationcat-new' + relationCount);
        var relationOrder = newDiv.find("input[name=relationorder-new]");
        relationOrder.attr('name', 'relationorder-new' + relationCount);
        var textArea = newDiv.find("textarea")
        textArea.attr('name', 'relationdetail-new' + relationCount);
        newDiv.css('display', 'block');
        var deleteButton = newDiv.find("#delete-relation");
        deleteButton.click(function() {
            deleteRelation($(this));
        });
    });
    
    $('a#delete-relation').click(function(event) {
        deleteRelation($(this));
    });
    
    $('a#add-hook').click(function() {
        var hookCount = $("#hook-container").children().length;
        var newDiv = $("#new-hook-field").clone();
        newDiv.appendTo("#hook-container");
        var hookName = newDiv.find("input[name=hookname-new]");
        hookName.attr('name', 'hookname-new' + hookCount);
        var hookDesc = newDiv.find("input[name=hookdesc-new]");
        hookDesc.attr('name', 'hookdesc-new' + hookCount);
        newDiv.css('display', 'block');
        var deleteButton = newDiv.find("#delete-hook");
        deleteButton.click(function() {
            deleteHook($(this));
        });
    });
    
    $('a#delete-hook').click(function(event) {
        deleteHook($(this));
    });
    
    //$('#profileimage-select').change(function() { 
    //    var selectedValue = $(this).val();
    //    $('#profileimage').val(selectedValue);
    //});
    
    $('a#show-file-upload').click(function(event) {
        $(this).hide();
        $('a#hide-file-upload').show();
        $('#file-upload-frame').show();
        $('html, body').animate({
                scrollTop: $(this).offset().top
            }, 100);
    });

    $('a#hide-file-upload').click(function(event) {
        $(this).hide();
        $('a#show-file-upload').show();
        $('#file-upload-frame').hide();
        $('html, body').animate({
                scrollTop: $(this).offset().top
            }, 100);
    });
    
  });

  return;

}).call(this);
