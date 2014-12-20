module AresMUSH
  module Mail
    class MailBackupCmd
      include Plugin
      include PluginRequiresLogin
           
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("backup")
      end
      
      def handle
        client.char.mail.each_with_index do |delivery, i|
          Global.dispatcher.queue_timer(i, "Mail Backup #{client.char.name}") do
            Global.logger.debug "Logging mail #{delivery.id} from #{client.char.name}."
            client.emit Mail.message_renderer.render(client, delivery)
          end
        end
      end
    end
  end
end
