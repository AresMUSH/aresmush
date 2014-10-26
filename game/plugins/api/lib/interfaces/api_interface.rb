module AresMUSH
  module Api
    def self.sync_char_with_master(client)
      char = client.char
      return if char.handle.blank?
      return if Global.api_router.is_master?
      
      args = ApiSyncCmdArgs.new(char.api_character_id, 
        char.handle, 
        char.name, 
        char.handle_privacy)
      cmd = ApiCommand.new("sync", args.to_s)
      Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
    end
  end
end