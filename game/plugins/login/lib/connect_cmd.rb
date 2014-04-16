module AresMUSH
  module Login
    class ConnectCmd
      include Plugin
      include PluginWithoutSwitches

      attr_accessor :charname, :password
      
      def want_command?(client, cmd)
        cmd.root_is?("connect")
      end
      
      def crack!
        cmd.crack!(/(?<name>[\S]+) (?<password>.+)/)
        self.charname = trim_input(cmd.args.name)
        self.password = cmd.args.password
      end
      
      def check_for_guest_or_password
        return t('login.maybe_you_meant_tour') if cmd.raw.downcase.chomp == "connect guest"
        return t('dispatcher.invalid_syntax', :command => 'connect') if self.password.nil? || self.charname.nil?
        return nil
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.charname, client) do |char|
          if (!char.compare_password(password))
            client.emit_failure(t('login.password_incorrect'))
            return 
          end

          # Handle reconnect
          existing_client = Global.client_monitor.find_client(char)
          client.char = char
          
          if (!existing_client.nil?)
            existing_client.disconnect
            EM.add_timer(1) { announce_connection }
          else
            Global.dispatcher.on_event(:char_connected, :client => client)
          end
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
