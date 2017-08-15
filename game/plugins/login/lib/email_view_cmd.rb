module AresMUSH
  module Login
    class EmailViewCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|
          
          if !Login.can_access_email?(enactor, char)
            client.emit_failure t('dispatcher.not_allowed') 
            return
          end
          
          if (!char.login_email)
            client.emit_ooc(t('login.no_email_is_registered', :name => char.name))
          else
            client.emit_ooc(t('login.email_registered_is', :name => char.name, 
                :email => char.login_email))
          end
        end
      end
    end
  end
end
