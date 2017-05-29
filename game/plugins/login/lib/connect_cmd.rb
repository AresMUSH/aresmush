module AresMUSH
  module Login
    class ConnectCmd
      include CommandHandler

      attr_accessor :charname, :password
      
      def parse_args
        self.charname = cmd.args ? trim_arg(cmd.args.before(" ")) : nil
        self.password = cmd.args ? cmd.args.after(" ") : nil
      end
      
      def allow_without_login
        true
      end
      
      def check_for_guest_or_password
        return t('dispatcher.invalid_syntax', :command => 'connect') if !self.password || !self.charname
        return nil
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def check_banned
        return t('login.site_blocked') if Login.is_banned?(client)
        return nil
      end
      
      def handle
        return if self.charname.downcase == "guest"
        

        ClassTargetFinder.with_a_character(self.charname, client, enactor) do |char|
  
          if (char.login_failures > 5)
            temp_reset = false
            
            if (char.handle)
              AresMUSH.with_error_handling(client, "AresCentral forgotten password.") do
                Global.logger.info "Checking AresCentral for forgotten password."
      
                connector = AresCentral::AresConnector.new
                response = connector.reset_password(char.handle.handle_id, self.password, char.id.to_s)
      
                if (response.is_success? && response.data["matched"])
                  client.emit_ooc t('login.temp_password_set', :password => self.password)
                  char.change_password self.password
                end
              end
            end
            
            if (!temp_reset)
              Global.logger.info "#{self.charname} locked due to repeated login failures."
              client.emit_failure(t('login.password_locked'))
              return
            end
          end
            
          if (!char.compare_password(password))
            Global.logger.info "Failed login attempt #{char.login_failures} to #{self.charname} from #{client.ip_addr}."
            char.update(login_failures: char.login_failures + 1)
            client.emit_failure(t('login.password_incorrect'))
            return 
          end

          terms_of_service = Login::Api.terms_of_service
          if (terms_of_service && !char.terms_of_service_acknowledged  && !client.program[:tos_accepted])
            client.program[:login_cmd] = cmd
            client.emit "%l1%r#{terms_of_service}%r#{t('login.tos_agree')}%r%l1"
            return
          end
        
          client.program.delete(:login_cmd)
          
          if (terms_of_service)
            char.update(terms_of_service_acknowledged: Time.now)
          end
          
          char.update(login_failures: 0)
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
