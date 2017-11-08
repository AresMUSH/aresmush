(function() {
    $(document).ready(function() {
        var notification_socket = null;
        notification_socket = new WebSocket(`ws://${config.host}:${config.port}/websocket`);
        
        notification_socket.onopen = function() {          
          var charId = $('#charId').val();
            cmd = {
              'type': 'identify',
              'data': { 'id': charId }
            };
            json = JSON.stringify(cmd);
            return notification_socket.send(json);
        };
        
        notification_socket.onmessage = function(evt) {
            var data;
            
            try
            {
               data = JSON.parse(evt.data);
            }
            catch(e)
            {
                data = null;
            }
            
            if (!data) {
                return;
            }
            
            var recipient = data.args.character;
            var charId = $('#charId').val();

            if (!recipient || recipient === charId) {
                var formatted_msg = ansi_up.ansi_to_html(data.args.message, { use_classes: true });
                alertify.notify(formatted_msg, 'success', 10);
                
                if (data.args.notification_type == "new_mail") {
                    var mail_badge = $('#mailBadge');
                    var mail_count = mail_badge.text();
                    mail_count = parseInt( mail_count );
                    mail_badge.text(mail_count + 1);
                }
            }
        }
    });

    return;

}).call(this);
