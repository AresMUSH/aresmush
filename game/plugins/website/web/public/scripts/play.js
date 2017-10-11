(function() {
  $(document).ready(function() {
    var connect, connected, debug, notification, on_connect, on_disconnect, send_cmd, send_input, ws, window_visible;
    ws = null;
    connected = false;
    window_visible = true;
    idle_keepalive_ms = 60000;
    keepalive_interval = null;
    
    $('button.disconnectButton').hide();
    $('button.connectButton').show();
    $('button.helpButton').hide();
    $('button.tourButton').hide();
    $('button.whoButton').hide();
    notification = window.Notification || window.mozNotification || window.webkitNotification;
    if (notification) {
      notification.requestPermission();
    }
    debug = function(str) {
      $('#debug').empty().append('<p>' + str + '</p>');
    };
    send_cmd = function(name, data) {
      var cmd, json;
      cmd = {
        'type': 'cmd',
        'cmd_name': name,
        'data': data
      };
      json = JSON.stringify(cmd);
      return ws.send(json);
    };
    send_input = function(msg) {
      var cmd, json;
      cmd = {
        'type': 'input',
        'message': msg
      };
      json = JSON.stringify(cmd);
      ws.send(json);
    };
    $(window).blur(function(){
        window_visible = false;
    });
    $(window).focus(function(){
        window_visible = true;
    });
    idleKeepalive = function() {
        if (connected) {
            send_input("keepalive");
        }
        else {
            clearInterval(keepalive_interval);
        }
    };
    
    connect = function() {
      ws = new WebSocket(`ws://${config.host}:${config.port}/websocket`);
      keepalive_interval = window.setInterval(function(){ idleKeepalive() }, idle_keepalive_ms);        
          
      ws.onmessage = function(evt) {
        var html, is_json;
        var data = evt.data;
        try
        {
           data = JSON.parse(evt.data);
           is_json = true;
        }
        catch(e)
        {
            data = evt.data;
            is_json = false;
        }
        
        if (is_json) {
            return;
        }
        
        html = ansi_up.ansi_to_html(data);
        $('#console').append('<p><pre>' + html + '</pre></p>');
        $('#console').stop().animate({
          scrollTop: $('#console')[0].scrollHeight
        }, 800);
        if (notification && notification.permission === "granted" && !window_visible) {
          new Notification(`Activity in ${config.mu_name}!`);
        }
      };
      ws.onclose = function() {
        debug('Disconnected!');
        on_disconnect();
      };
      ws.onopen = function() {
        debug('Connected!');
        on_connect();
      };
    };
    on_connect = function() {
      var charId, charToken, data;
      connected = true;
      $('button.disconnectButton').show();
      $('button.connectButton').hide();
      $('button.helpButton').show();
      $('button.tourButton').show();
      $('button.whoButton').show();
      document.getElementById("sendMsg").focus();
      //charId = $('#charId').val();
      //charToken = $('#charToken').val();
      //if (charId !== ' ') {
        //data = {
        //  'id': "" + charId,
        //  'login_api_token': "" + charToken
            //};
        //send_cmd('connect', data);
      //}
    };
    on_disconnect = function() {
      connected = false;
      $('button.disconnectButton').hide();
      $('button.connectButton').show();
      $('button.helpButton').hide();
      $('button.tourButton').hide();
      $('button.whoButton').hide();
    };
    on_text_event = function(e, control) {
        var msg;
        if (connected === false) {
          debug('Not connected!');
          return;
        }
        if (e.which === 13) {
          send_and_clear_input(control);
          return false;
        }
    };
    send_and_clear_input = function(control) {
        msg = $(control).val();
        send_input(msg);
        $(control).val('');
    };
    $('button.sendButton').click(function() {
      send_and_clear_input('#sendMsg');
      document.getElementById("sendMsg").focus();
    });
    $('button.sendButton2').click(function() {
      send_and_clear_input('#sendMsg2');
      document.getElementById("sendMsg2").focus();
    });
    $('button.disconnectButton').click(function() {
      send_input('quit');
      document.getElementById("sendMsg").focus();
    });
    $('button.helpButton').click(function() {
      send_input('help');
      document.getElementById("sendMsg").focus();
    });
    $('button.pingButton').click(function() {
      send_cmd('ping', '');
      $('#sendMsg').val('');
    });
    $('button.whoButton').click(function() {
      send_input('who');
      document.getElementById("sendMsg").focus();
    });
    $('button.tourButton').click(function() {
      send_input('tour');
      document.getElementById("sendMsg").focus();
    });
    $('button.connectButton').click(function() {
      connect();
      document.getElementById("sendMsg").focus();
    });
    $('#sendMsg').keypress(function(e) {
        return on_text_event(e, '#sendMsg');
    });
    $('#sendMsg2').keypress(function(e) {
        return on_text_event(e, '#sendMsg2');
    });
  });

  return;

}).call(this);
