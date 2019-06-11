module AresMUSH
    module Txt

      def self.format_txt_indicator(char, names)
        t('txt.txt_indicator',
#        :start_marker => Global.read_config("page", "page_start_marker") || "<",
#        :end_marker => Global.read_config("page", "page_end_marker") || "<",
        :start_marker => "(",
        :recipients => names,
        :end_marker => ")",
        :color => Txt.txt_color(char) )
      end

      def self.format_recipient_indicator(recipients)
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
        if scene_id
          Login.emit_if_logged_in recipient, "#{message} %xh%xx(Scene #{scene_id})"
          Page.send_afk_message(client, recipient_client, recipient)
        else
          Login.emit_if_logged_in recipient, message
          Page.send_afk_message(client, recipient_client, recipient)
        end

        txt_received = "#{recipient_names}" + " #{sender.name}"
        txt_received.slice! "#{recipient.name}"
        recipient.update(txt_received: (txt_received.squish))
        recipient.update(txt_received_scene: scene_id)
      end


    end
end
