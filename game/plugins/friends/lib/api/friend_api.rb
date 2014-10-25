module AresMUSH
  module Friends
    def self.add_handle_friend(client, friend_name)
      if (Global.api_router.is_master?)
        client.emit_failure t('friends.cant_manage_handle_friends_on_master')
      else
        if (!client.char.handle)
          client.emit_failure t('api.no_handle_set')
          return
        end
        args = ApiFriendCmdArgs.new(client.char.api_character_id, client.char.handle, friend_name)
        cmd = ApiCommand.new("friend/add", args.to_s)
        client.emit_success t('friends.sending_friends_request')
        Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
    
    def self.remove_handle_friend(client, friend_name)
      if (Global.api_router.is_master?)
        client.emit_failure t('friends.cant_manage_handle_friends_on_master')
      else
        if (!client.char.handle)
          client.emit_failure t('api.no_handle_set')
          return
        end
        args = ApiFriendCmdArgs.new(client.char.api_character_id, client.char.handle, friend_name)
        cmd = ApiCommand.new("friend/remove", args.to_s)
        client.emit_success t('friends.sending_friends_request')
        Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
  end
end