module AresMUSH
  module Handles
    def self.send_handle_profile_request(client, handle_name)
      client.emit_success t('handles.sending_profile_request')
      args = ApiProfileCmdArgs.new(handle_name, client.char.handle)
      cmd = ApiCommand.new("profile", args.to_s)
      Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
    end
  end
end