module AresMUSH
  module Handles
    class HandleLinkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :handle_name, :link_code

      def initialize
        self.required_args = ['handle_name', 'link_code']
        self.help_topic = 'handle'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.handle_name = cmd.args.arg1
        self.link_code = cmd.args.arg2
      end
      
      def check_handle_name
        #return t('handles.character_already_linked') if client.char.handle
        return nil
      end
      
      def handle
        char = client.char

        # Strip off the @ a thte front if they made one.
        self.handle_name.sub!(/^@/, '')
        
        AresMUSH.with_error_handling(client, "Linking char to AresCentral handle.") do
          Global.logger.info "Linking #{char.name} to #{self.handle_name}."
        
          connector = AresCentral::AresConnector.new
          response = connector.link_char(self.handle_name, self.link_code, char.name, char.id.to_s)
        
          if (response.is_success?)
            char.handle = response.data["handle_name"]
            char.handle_id = response.data["handle_id"]
            char.save
        
            client.emit_success t('handles.link_successful', :handle => self.handle_name)
          else
            client.emit_failure t('handles.link_failed', :error => response.error_str)
          end   
        end     
      end      
    end

  end
end
