(function() {
  $(document).ready(function() {
   
      deleteProfile = function(deleteButtonObj) {
          var profile = deleteButtonObj.parent().parent().parent();
          profile.remove();
      };
      
      deleteRelation = function(deleteRelationObj) { 
          var relation = deleteRelationObj.parent().parent().parent();
          relation.remove();
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
    
  });

  return;

}).call(this);
