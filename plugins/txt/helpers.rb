module AresMUSH
    module Txt

      def self.format_txt_indicator(char, names)
        t('txt.txt_indicator',
       :start_marker => Global.read_config("txt", "txt_start_marker") || "(", :end_marker => Global.read_config("txt", "txt_end_marker") || ")",  :preface => Global.read_config("txt", "txt_preface"),  :recipients => names, :color => Txt.txt_color(char) )
      end

      def self.format_recipient_display_names(recipients, sender)
        use_nick = Global.read_config("txt", "use_nick")
        use_only_nick = Global.read_config("txt", "use_only_nick")
        recipient_display_names = []
        sender_name = sender.name
        recipients.each do |char|
          if use_nick
            recipient_display_names.concat [char.nick]
            sender_name = sender.nick || sender.name
          elsif use_only_nick
            nickname_field = Global.read_config("demographics", "nickname_field") || ""
            if (char.demographic(nickname_field))
              recipient_display_names.concat [char.demographic(nickname_field)]
              sender_name = sender.demographic(nickname_field) || sender.name
            else
              recipient_display_names.concat [char.name]
            end
          else
            recipient_display_names.concat [char.name]
          end
        end
        recipient_display_names.delete(sender_name)
        if use_nick || use_only_nick
          recipients = recipient_display_names.join(", ")
        else
          recipients = recipient_display_names.join(" ")
        end
        return t('txt.recipient_indicator', :recipients => recipients)
      end

      def self.format_sender_display_name(sender)
        use_nick = Global.read_config("txt", "use_nick")
        use_only_nick = Global.read_config("txt", "use_only_nick")
        if use_nick
          sender_display_name = sender.nick
        elsif use_only_nick
          nickname_field = Global.read_config("demographics", "nickname_field") || ""
          if (sender.demographic(nickname_field))
            sender_display_name = sender.demographic(nickname_field)
          else
            sender_display_name = sender.name
          end
        else
          sender_display_name = sender.name
        end
        return sender_display_name
      end

      def self.format_recipient_names(recipients)
        recipient_names = []
        recipients.each do |char|
          if !char
            return { error: t('txt.no_such_character') }
          else
            recipient_names.concat [char.name]
          end
        end
        return t('txt.recipient_indicator', :recipients => recipient_names.join(" "))
      end

      def self.txt_color(char)
        char.txt_color || "%xh%xy"
      end

      def self.txt_recipient(sender, recipient, recipient_names, message, scene_id = nil)
        client = Login.find_game_client(sender)
        recipient_client  = Login.find_game_client(recipient)
        Login.emit_if_logged_in recipient, message
      end

      def self.uninstall_plugin(client)
        begin 
          Character.all.each do |c|
            c.update(txt_last: nil)
            c.update(txt_last_scene: nil)
            c.update(txt_received: nil)
            c.update(txt_received_scene: nil)
            c.update(txt_color: nil)
            c.update(txt_scene: nil)
          end
           Manage.uninstall_plugin("txt")
           client.emit_success "Plugin uninstalled."
      
         rescue Exception => e
           client.emit_failure "Error uninstalling plugin: #{e} backtrace=#{e.backtrace[0,10]}"
         end
       end
    end
end
