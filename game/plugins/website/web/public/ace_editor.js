(function() {
  $(document).ready(function() {
      
      var editor = ace.edit("editor");
      editor.setTheme("ace/theme/cobalt");

      var title = document.getElementById('path').value;
      editor.getSession().setMode("ace/mode/yaml");
      if (title.endsWith('erb')) {
          editor.getSession().setMode("ace/mode/html_ruby");
      }
      else if (title.endsWith('md')) {
          editor.getSession().setMode("ace/mode/markdown");
          editor.getSession().setUseWrapMode(true);
      }
      else if (title.endsWith('txt')) {
          editor.getSession().setMode("ace/mode/plain_text");
          editor.getSession().setUseWrapMode(true);
      }
      var contents = document.getElementById('contents');
      contents.value = editor.getValue();

      editor.getSession().on('change', function(e) {
          var contents = document.getElementById('contents');
          contents.value = editor.getValue(); 
      }); 
      
  });

  return;

}).call(this);
