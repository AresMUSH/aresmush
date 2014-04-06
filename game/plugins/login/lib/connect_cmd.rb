module AresMUSH
  module Login
    class ConnectCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :charname, :password
      
      def initialize
        self.required_args = ['charname', 'password']
        self.help_topic = 'connect'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("connect")
      end
      
      def crack!
        cmd.crack!(/(?<name>[\S]+) (?<password>.+)/)
        self.charname = trim_input(cmd.args.name)
        self.password = cmd.args.password
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
            announce_connection
          end
        end
      end
      
      def announce_connection
        Global.dispatcher.on_event(:char_connected, :client => client)
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
