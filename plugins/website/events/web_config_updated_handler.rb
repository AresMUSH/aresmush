module AresMUSH
  module Website
    class WebConfigUpdatedEventHandler
      def on_event(event)
        file_path = File.join(AresMUSH.website_scripts_path, 'aresconfig.js')

        config = {
          "port" => Global.read_config("server", "websocket_port"),
          "mu_name" => Global.read_config("game", "name"),
          "host" => Global.read_config("server", "hostname"),
          "api_port" => Global.read_config("server", "engine_api_port"),
          "api_key" => Game.master.engine_api_key,
          "version" => AresMUSH.version
        }
        
        File.open(file_path, 'w') do |f|
          f.write "var aresconfig = #{config.to_json};"
        end
      end
    end
  end
end