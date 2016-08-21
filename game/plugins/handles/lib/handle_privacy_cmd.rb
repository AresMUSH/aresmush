module AresMUSH
  module Handles
    class HandlePrivacyCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'handles'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("privacy")
      end
      
      def crack!
        self.option = cmd.args.nil? ? nil : trim_input(cmd.args).downcase
      end
      
      def check_option
        values = [ Handles.privacy_public, Handles.privacy_admin, Handles.privacy_friends ]
        return t('handles.invalid_privacy_option', :values => values.join(" ")) if !values.include?(self.option)
        return nil
      end
      
      def check_handle
        return t('handles.no_handle_set') if client.char.handle.blank?
        return nil
      end      
        
      def handle        
        client.char.handle_privacy = self.option
        client.char.save
        client.emit_ooc t('handles.privacy_set', :value => self.option)
        Handles.sync_char_with_master(client)
      end
    end
  end
end
