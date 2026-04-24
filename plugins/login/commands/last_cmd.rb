module AresMUSH
  module Login
    class LastCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |target|
          other_client = Login.find_game_client(target)
          if (other_client)
            client.emit_ooc t('login.currently_online', :name => target.name)
          else
            last = OOCTime.local_long_timestr(enactor, target.last_on)
            client.emit_ooc t('login.last_online', :name => target.name, :time => last)
          end
        end
      end
    end
  end
end
