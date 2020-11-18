module AresMUSH
    module Txt

      def self.format_txt_indicator(char, names)
        t('txt.txt_indicator',
       :start_marker => Global.read_config("txt", "txt_start_marker") || "(", :end_marker => Global.read_config("txt", "txt_end_marker") || ")",  :recipients => names, :color => Txt.txt_color(char) )
      end

      def self.format_recipient_display_names(recipients)
        puts "Recipients #{recipients}"
        use_nick = Global.read_config("txt", "use_nick")
        use_only_nick = Global.read_config("txt", "use_only_nick")
        recipient_display_names = []
        recipients.each do |char|
          if use_nick
            recipient_display_names.concat [char.nick]
          elsif use_only_nick
            nickname_field = Global.read_config("demographics", "nickname_field") || ""
            if (char.demographic(nickname_field))
              recipient_display_names.concat [char.demographic(nickname_field)]
            else
              recipient_display_names.concat [char.name]
            end
          else
            recipient_display_names.concat [char.name]
          end
        end

        return t('txt.recipient_indicator', :recipients => recipient_display_names.join(" "))
      end

      def self.format_recipient_names(recipients)
        recipient_names = []
      recipients.each do |char|
          recipient_names.concat [char.name]
        end
        return t('txt.recipient_indicator', :recipients => recipient_names.join(" "))
      end

      def self.txt_color(char)
        char.txt_color || "%xh%xy"
      end

      def self.txt_recipient(sender, recipient, recipient_names, message, scene_id)
        client = Login.find_client(sender)
        recipient_client  = Login.find_client(recipient)
        use_only_nick = Global.read_config("txt", "use_only_nick")

        if scene_id
          if use_only_nick
            txt_end = "%xh%xx(#{sender.name} in scene #{scene_id})%xn%xn"
          else
            txt_end = "%xh%xx(Scene #{scene_id})%xn%xn"
          end
          Login.emit_if_logged_in recipient, "#{message} #{txt_end}"
          Page.send_afk_message(client, recipient_client, recipient)
        else
          if use_only_nick
            txt_end = "%xh%xx(#{sender.name}"
          else
            txt_end = ""
          end
          Login.emit_if_logged_in recipient,  "#{message} #{txt_end}"
          Page.send_afk_message(client, recipient_client, recipient)
        end

        txt_received = "#{recipient_names}" + " #{sender.name}"
        txt_received.slice! "#{recipient.name}"
        recipient.update(txt_received: (txt_received.squish))
        recipient.update(txt_received_scene: scene_id)
      end


    end
end
