module AresMUSH
  module Utils
    class LastCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'last'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("last")
      end
      
      def crack!
        self.name = trim_input(cmd.args)
      end

      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |target|
          other_client = target.client
          if (!other_client.nil?)
            client.emit_ooc t('last.currently_online', :name => target.name)
          else
            last = OOCTime::Interface.local_long_timestr(client, Manage::Interface.last_on(target))
            client.emit_ooc t('last.last_online', :name => target.name, :time => last)
          end
        end
      end
    end
  end
end
