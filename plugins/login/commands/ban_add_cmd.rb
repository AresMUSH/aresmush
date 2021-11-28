module AresMUSH
  module Login
    class BanAddCmd
      include CommandHandler
      
      attr_accessor :site, :desc
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.site = downcase_arg(args.arg1)
        self.desc = args.arg2
      end
      
      def required_args
        [ self.site, self.desc ]
      end
      
      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        error = Login.add_site_ban(enactor, self.site, self.desc)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('login.ban_added')
        end
      end
    end
  end
end
