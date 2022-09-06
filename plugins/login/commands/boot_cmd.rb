module AresMUSH
  module Login
    class BootCmd
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

      def check_approved
        return nil if enactor.is_approved? || enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |bootee|
                    
          error = Login.boot_char(enactor, bootee, self.reason)
          if (error)
            client.emit_failure error
          end
          
          client.emit_success t('login.booted_player', :name => self.target)
          
        end
      end
    end
  end
end
