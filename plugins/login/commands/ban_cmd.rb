module AresMUSH
  module Login
    class BanCmd
      include CommandHandler
      
      attr_accessor :target, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.target = trim_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.target, self.reason ]
      end

      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          
          error = Login.ban_player(enactor, model, self.reason)
          if (error)
            client.emit_failure t('manage.ban_config_error', :name => model.name, :error => error)
          else
            client.emit_success t('manage.player_banned', :name => model.name)
          end
        end
      end
    end
  end
end
