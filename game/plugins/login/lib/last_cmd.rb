module AresMUSH
  module Login
    class LastCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def crack!
        self.name = trim_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'last'
        }
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |target|
          other_client = target.client
          if (other_client)
            client.emit_ooc t('login.currently_online', :name => target.name)
          else
            last = OOCTime::Api.local_long_timestr(enactor, target.last_on)
            client.emit_ooc t('login.last_online', :name => target.name, :time => last)
          end
        end
      end
    end
  end
end
