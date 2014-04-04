module AresMUSH
  module Login
    class EmailViewCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("email") && cmd.switch.nil?
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end

      # TODO - check permissions if viewing someone else's email
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          if (char.email.nil?)
            client.emit_ooc(t('login.no_email_is_registered', :name => self.name))
          else
            client.emit_ooc(t('login.email_registered_is', :name => self.name, :email => char.email))
          end
        end
      end
    end
  end
end
