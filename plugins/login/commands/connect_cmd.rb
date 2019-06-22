module AresMUSH
  module Login
    class ConnectCmd
      include CommandHandler

      attr_accessor :charname, :password
      
      def parse_args
        self.charname = cmd.args ? titlecase_arg(cmd.args.before(" ")) : nil
        self.password = cmd.args ? cmd.args.after(" ") : nil
      end
      
      def allow_without_login
        true
      end
      
      def check_for_guest_or_password
        return t('dispatcher.invalid_syntax', :cmd => 'connect') if !self.password || !self.charname
        return nil
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        return if self.charname.downcase == "guest"

        ClassTargetFinder.with_a_character(self.charname, client, enactor) do |char|
  
          result = Login.check_login(char, self.password, client.ip_addr, client.hostname)
          
          if result[:status] == 'unlocked'
            client.emit_ooc t('login.temp_password_set', :password => self.password)
          elsif result[:status] == 'error'
            client.emit_failure result[:error]
            return
          end
            
          terms_of_service = Login.terms_of_service
          if (terms_of_service)
            
            if (!char.terms_of_service_acknowledged  && !client.program[:tos_accepted])
              client.program[:login_cmd] = cmd
              template = BorderedDisplayTemplate.new "#{terms_of_service}%r#{t('login.tos_agree')}"
              client.emit template.render
              return
            end
            char.update(terms_of_service_acknowledged: Time.now)
          end
        
          client.program.delete(:login_cmd)
          
          Login.login_char(char, client)          
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
