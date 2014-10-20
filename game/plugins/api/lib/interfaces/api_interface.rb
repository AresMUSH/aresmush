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
    
    def self.get_link_code(client, char_id)
      if (Api.is_master?)
        random_key = Api.random_link_code
        client.char.temp_link_codes[char_id] = random_key
        client.char.save!
        client.emit_success t('api.link_key_is', :key => random_key)
      else
        client.emit_failure t('api.use_command_on_central')
      end
    end
    
    def self.link_character(client, handle, link_code)
      if (Api.is_master?)
        client.emit_failure t('api.cant_link_on_master')
      else
        if (client.char.handle)
          client.emit_failure t('api.character_already_linked')
          return
        end
        client.emit_success t('api.sending_link_request')
        args = ApiLinkCmdArgs.new(handle, client.char.api_character_id, client.name, link_code)
        cmd = ApiCommand.new("link", args.to_s)
        Api.send_command(ServerInfo.arescentral_game_id, client, cmd)
      end
    end
    
    def self.unlink_character(client, char_id)
      if (Api.is_master?)
        linked_char = client.char.linked_characters[char_id]
        if (!linked_char)
          client.emit_failure t('api.character_not_linked')
          return
        end
                        
        args = ApiUnlinkCmdArgs.new("@#{client.name}", char_id)
        cmd = ApiCommand.new("unlink", args.to_s)
        Api.send_command(linked_char["game_id"].to_i, nil, cmd)

        client.char.linked_characters.delete char_id
        client.char.save
        client.emit_success t('api.character_unlinked', :name => linked_char["name"])
      else
        client.emit_failure t('api.use_command_on_central')
        
      end
    end
    
    def self.list_characters(client)
      if (Api.is_master?)
        list = []
        list << t('api.characters_title')
        list << "%l2"
        client.char.linked_characters.each do |k, v| 
          name = "#{v['name']}@#{Api.get_destination(v['game_id']).name}"
          list << "#{name.ljust(40)} #{k}"
        end
        client.emit BorderedDisplay.list list, t('api.linked_characters')
      else
        client.emit_failure t('api.use_command_on_central')
      end
    end
   
  end
end