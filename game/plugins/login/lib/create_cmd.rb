module AresMUSH
  module Login
    class CreateCmd
      include CommandHandler
      include CommandWithoutSwitches
      
      attr_accessor :charname, :password

      def crack!
        # After agreeing to TOS, this is already cracked.
        if (cmd.args.class != AresMUSH::HashReader)
          cmd.crack_args!(CommonCracks.arg1_space_arg2)
        end
        self.charname = trim_input(cmd.args.arg1)
        self.password = cmd.args.arg2
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end      
      
      def check_name
        return t('dispatcher.invalid_syntax', :command => 'create') if !charname
        return t('validation.name_must_be_capitalized') if (charname[0].downcase == charname[0])
        return Character.check_name(charname)
      end
      
      def check_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if !password
        return Character.check_password(password)
      end
      
      def handle
        terms_of_service = Login.terms_of_service
        if (terms_of_service && client.program[:tos_accepted].nil?)
          client.program[:create_cmd] = cmd
          client.emit "%l1%r#{terms_of_service}%r#{t('login.tos_agree')}%r%l1"
          return
        end
        
        client.program.delete(:create_cmd)
        
        char = Character.new
        char.name = charname
        char.change_password(password)
        if (terms_of_service)
          char.terms_of_service_acknowledged = Time.now
        end
        char.save!
        
        client.emit_success(t('login.created_and_logged_in', :name => charname))
        client.char = char
        Global.dispatcher.queue_event CharCreatedEvent.new(client, char)
        Global.dispatcher.queue_event CharConnectedEvent.new(client, char)
      end
      
      def log_command
        # Don't log full command for privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end      
    end
  end
end
