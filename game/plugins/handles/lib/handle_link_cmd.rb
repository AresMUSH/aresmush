module AresMUSH
  module Handles
    class HandleLinkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :handle_name, :code

      def initialize
        self.required_args = ['handle_name', 'code']
        self.help_topic = 'handle'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("link")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.handle_name = cmd.args.arg1
        self.code = cmd.args.arg2
      end
      
      def check_is_handle
        return t('handles.invalid_handle') if !Handles.handle_name_valid?(self.handle_name)
        return nil
      end
      
      def handle
        if (client.char.handle)
          client.emit_failure t('handles.character_already_linked')
          return
        end
        client.emit_success t('handles.sending_link_request')
        args = ApiLinkCmdArgs.new(handle, client.char.api_character_id, client.name, link_code)
        cmd = ApiCommand.new("link", args.to_s)
        Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
        
        char = client.char
        char.handle = self.args.handle_name
        char.handle_privacy = Handles.privacy_friends
        char.handle_sync = true
        char.save!
        client.emit_success t('handles.link_successful', :handle => self.args.handle_name)
        client.emit_ooc t('handles.privacy_set', :value => Handles.privacy_friends)
        # TODO Is sync necessary?  Can't we just set info here?
        Handles.sync_char_with_master(client)
        
      end      
    end

  end
end
