module AresMUSH
  module Login
    class BanRemoveCmd
      include CommandHandler
      
      attr_accessor :site
      
      def parse_args
        self.site = downcase_arg(cmd.args)
      end
      
      def required_args
        [ self.site ]
      end
      
      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        error = Login.remove_site_ban(enactor, self.site)
        if (error)
          client.emit_failure error
        else
          client.emit_success t('login.ban_removed')
        end
      end
    end
  end
end
