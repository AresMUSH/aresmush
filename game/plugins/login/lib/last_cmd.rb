module AresMUSH
  module Login
    class LastCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'last'
        super
      end
      
      def crack!
        self.name = trim_input(cmd.args)
      end

      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |target|
          other_client = target.client
          if (!other_client.nil?)
            client.emit_ooc t('login.currently_online', :name => target.name)
          else
            last = OOCTime::Api.local_long_timestr(client, Login::Api.last_on(target))
            client.emit_ooc t('login.last_online', :name => target.name, :time => last)
          end
        end
      end
    end
  end
end
