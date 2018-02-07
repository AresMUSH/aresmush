module AresMUSH
  module Website
    class WebConfigUpdatedEventHandler
      def on_event(event)
        file_path = File.join(AresMUSH.game_path, 'aresconfig.js')

        config = {
          "mush_port" => Global.read_config("server", "port"),
          "web_portal_port" => Global.read_config("server", "web_portal_port"),
          "websocket_port" => Global.read_config("server", "websocket_port"),
          "version" => AresMUSH.version,
          "host" => Global.read_config("server", "hostname"),
          "api_port" => Global.read_config("server", "engine_api_port"),
          "api_key" => Game.master.engine_api_key,
          "styles_path" => AresMUSH.website_styles_path,
          "uploads_path" => AresMUSH.website_uploads_path
        }
        
        File.open(file_path, 'w') do |f|
          f.write "var aresconfig = #{config.to_json};"
        end
        
        WebHelpers.rebuild_css
      end
    end
  end
end