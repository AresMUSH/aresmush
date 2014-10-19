module AresMUSH
  module Api
    
    def self.add_handle_friend(client, friend_name)
      if (Api.is_master?)
        client.emit_failure t('api.cant_manage_handle_friends_on_master')
      else
        if (!client.char.handle)
          client.emit_failure t('api.character_not_linked')
          return
        end
        args = ApiFriendCmdArgs.new(client.char.api_character_id, client.char.handle, friend_name)
        cmd = ApiCommand.new("friend/add", args.to_s)
        client.emit_success t('api.sending_friends_request')
        Api.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
    
    def self.remove_handle_friend(client, friend_name)
      if (Api.is_master?)
        client.emit_failure t('api.cant_manage_handle_friends_on_master')
      else
        if (!client.char.handle)
          client.emit_failure t('api.character_not_linked')
          return
        end
        args = ApiFriendCmdArgs.new(client.char.api_character_id, client.char.handle, friend_name)
        cmd = ApiCommand.new("friend/remove", args.to_s)
        client.emit_success t('api.sending_friends_request')
        Api.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
    
    def self.get_character_id(client)
      if (Api.is_master?)
        client.emit_failure t('api.cant_link_on_master')
      else
        client.emit_success t('api.character_id_is', :id => client.char.api_character_id)
      end
    end
    
    def self.link_character(client, handle, id_or_code)
      if (Api.is_master?)
        random_key = Api.random_link_code
        client.char.temp_link_codes[id_or_code] = random_key
        client.emit_success t('api.link_key_is', :key => random_key)
      else
        if (client.char.handle)
          client.emit_failure t('api.character_already_linked')
          return
        end
        client.emit_success t('api.sending_link_request')
        args = ApiLinkCmdArgs.new(handle, client.char.api_character_id, client.name, id_or_code)
        cmd = ApiCommand.new("link", args.to_s)
        Api.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
   
  end
end