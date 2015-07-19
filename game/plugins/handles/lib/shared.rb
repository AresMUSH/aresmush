module AresMUSH
  module Handles
    def self.send_handle_profile_request(client, handle_name)
      client.emit_success t('handles.sending_profile_request')
      args = ApiProfileCmdArgs.new(handle_name, client.char.handle)
      cmd = ApiCommand.new("profile", args.to_s)
      Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
    end
    
    def self.format_custom_profile(char)
      text = "%r%l2"
      char.profile.each_with_index do |(k, v), i|
        if (i == 0)
          text << "%R"
        else
          text << "%R%R"
        end
        text << "%xh#{k}%xn%R#{v}"
      end
      text
    end
    
    def self.get_visible_alts(model, actor)
      list = Handles.find_visible_alts(model.handle, actor)
      if (list.empty?)
        t('handles.no_alts')
      else
        list.map { |l| l.name }.join(", ")
      end
    end
  end
end