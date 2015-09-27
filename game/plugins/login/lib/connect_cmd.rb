module AresMUSH
  module Login
    class ConnectCmd
      include Plugin
      include PluginWithoutSwitches

      attr_accessor :charname, :password
      
      def want_command?(client, cmd)
        # Special check for 'c' command to allow it to be used as chat alias.
        return false if client.logged_in?
        return (cmd.root_is?("connect") || cmd.root_is?("c")) && cmd.args && !cmd.args.start_with?("guest")
      end
      
      def crack!
        self.charname = cmd.args ? trim_input(cmd.args.before(" ")) : nil
        self.password = cmd.args ? cmd.args.after(" ") : nil
      end
      
      def check_for_guest_or_password
        return t('dispatcher.invalid_syntax', :command => 'connect') if self.password.nil? || self.charname.nil?
        return nil
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        
        return if self.charname.downcase == "guest"
        
        ClassTargetFinder.with_a_character(self.charname, client) do |char|
          if (!char.compare_password(password))
            client.emit_failure(t('login.password_incorrect'))
            return 
          end

          # Handle reconnect
          existing_client = char.client
          client.char = char
          
          if (!existing_client.nil?)
            existing_client.emit_ooc t('login.disconnected_by_reconnect')
            existing_client.disconnect
            Global.dispatcher.queue_timer(1, "Announce Connection", client) { announce_connection }
          else
            announce_connection
          end
        end
      end
      
      def announce_connection
        Global.dispatcher.queue_event CharConnectedEvent.new(client)
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
