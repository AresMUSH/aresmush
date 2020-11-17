module AresMUSH
  module Login
    class CreateCmd
      include CommandHandler
      
      attr_accessor :charname, :password
      
      def parse_args
        self.charname = cmd.args ? trim_arg(cmd.args.before(" ")) : nil
        self.password = cmd.args ? cmd.args.after(" ") : nil
      end
      
      def allow_without_login
        true
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end      
      
      def check_name
        return t('dispatcher.invalid_syntax', :cmd => 'create') if !charname
        return Character.check_name(charname)
      end
      
      def check_password
        return t('dispatcher.invalid_syntax', :cmd => 'passsword') if !password
        return Character.check_password(password)
      end
      
      def check_banned
        return Login.site_blocked_message if Login.is_banned?(nil, client.ip_addr, client.hostname)
        return nil
      end
      
      def check_creation_disabled
        reason = Global.read_config('login', 'creation_not_allowed_message')
        return t('login.creation_restricted', :reason => reason) if !Login.creation_allowed?
        return nil
      end
      
      def check_name_taken
        return Login.name_taken?(self.charname)
      end
      
      def handle
        terms_of_service = Login.terms_of_service
        if (terms_of_service && client.program[:tos_accepted].nil?)
          client.program[:login_cmd] = cmd

          template = BorderedDisplayTemplate.new "#{terms_of_service}%r#{t('login.tos_agree')}"
          client.emit template.render

          return
        end
        
        client.program.delete(:login_cmd)
        
        char = Character.new
        char.name = charname
        char.change_password(password)
        char.room = Game.master.welcome_room

        if (terms_of_service)
          char.terms_of_service_acknowledged = Time.now
        end
        
        char.save
        
        client.emit_success(t('login.created_and_logged_in', :name => charname))
        client.char_id = char.id
        Global.dispatcher.queue_event CharCreatedEvent.new(client, char.id)
        Global.dispatcher.queue_event CharConnectedEvent.new(client, char.id)
      end
      
      def log_command
        # Don't log full command for privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end      
    end
  end
end
