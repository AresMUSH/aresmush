module AresMUSH
  module Api
    
    def self.add_handle_friend(client, friend_name)
      if (Api.is_master?)
        client.emit_failure t('api.cant_add_handle_friends_on_master')
      else
        args = ApiFriendCmdArgs.new(client.char.api_character_id, friend_name)
        cmd = ApiCommand.new("friend/add", args.to_s)
        client.emit_success t('api.sending_friends_request')
        Api.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
   
  end
end