module AresMUSH
  module AresCentral
    class HandleLinkCmd
      include CommandHandler
      
      attr_accessor :handle_name, :link_code

      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.handle_name = trim_arg(args.arg1)
        self.link_code = trim_arg(args.arg2)
      end

      def required_args
        [ self.handle_name, self.link_code ]
      end
      
      def check_guest
        return t('dispatcher.not_allowed') if (enactor.is_guest?)
        return nil
      end
      
      def check_handle_name
        return t('arescentral.character_already_linked') if enactor.handle
        return nil
      end
      
      def check_is_registered
        return t('arescentral.game_not_registered') if !AresCentral.is_registered?
        return nil
      end

      
      def handle
        # Strip off the @ a thte front if they made one.
        self.handle_name.sub!(/^@/, '')
        
        AresMUSH.with_error_handling(client, "Linking char to AresCentral handle.") do
          Global.logger.info "Linking #{enactor.name} to #{self.handle_name}."
        
          connector = AresCentral::AresConnector.new
          response = connector.link_char(self.handle_name, self.link_code, enactor.name, enactor.id.to_s)
        
          if (response.is_success?)
            handle = Handle.create(name: response.data["handle_name"], 
                handle_id: response.data["handle_id"],
                character: enactor)
            enactor.update(handle: handle)
            client.emit_success t('arescentral.link_successful', :handle => self.handle_name)
            
            Achievements.award_achievement(enactor, "handle_linked", 'community', "Linked a character to a player handle.")
          else
            client.emit_failure t('arescentral.link_failed', :error => response.error_str)
          end   
        end     
      end      
    end

  end
end
