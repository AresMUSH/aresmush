module AresMUSH
  module Api
    class ApiSendCmd
      include Plugin
           
      def want_command?(client, cmd)
        want = cmd.root_is?("api") && cmd.switch_is?("send")
        want
      end
      
      def handle
        client.emit_ooc t('api.sending_to_remote')
        Api.send_command ServerInfo.arescentral_game_id, client, cmd.args
      end
    end
  end
end


