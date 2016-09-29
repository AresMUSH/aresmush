module AresMUSH
  module Login
    class EmailViewCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :name

      def crack!
        self.name = cmd.args.nil? ? enactor_name : trim_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          
          if !Login.can_access_email?(enactor, char)
            client.emit_failure t('dispatcher.not_allowed') 
            return
          end
          
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
