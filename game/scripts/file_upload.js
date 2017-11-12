(function() {
  $(document).ready(function() {
   
     
    $('#fileselect').change(function() {
        var prefix = $('#prefix').val();
        
        var num_files = $(this).get(0).files.length;
        if (num_files != 1) {
            return;
        }
        var filename = $(this).get(0).files[0].name;
        $('#filename').val(prefix + filename);        
    });
       
  });

  return;

}).call(this);
