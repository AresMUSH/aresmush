module AresMUSH
  module Website
    class WebConfigUpdatedEventHandler
      def on_event(event)
        file_path = File.join(AresMUSH.game_path, 'plugins', 'website', 'web', 'public', 'config.js')

        config = {
          "port" => Global.read_config("server", "websocket_port"),
          "mu_name" => Global.read_config("game", "name"),
          "host" => Global.read_config("server", "hostname"),
        }
        
        File.open(file_path, 'w') do |f|
          f.write "var config = #{config.to_json};"
        end
      end
    end
  end
end