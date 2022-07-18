module AresMUSH
  module Website
    class WebConfigUpdatedEventHandler
      def on_event(event)
        file_path = File.join(AresMUSH.website_scripts_path, 'aresconfig.js')

        begin
          use_api_proxy = Global.use_api_proxy
        rescue
          use_api_proxy = false
        end
        
        config = {
          "mush_port" => Global.read_config("server", "port"),
          "web_portal_port" => Global.read_config("server", "web_portal_port"),
          "websocket_port" => Global.read_config("server", "websocket_port"),
          "version" => AresMUSH.version,
          "host" => Global.read_config("server", "hostname"),
          "api_port" => Global.read_config("server", "engine_api_port"),
          "api_key" => Website.engine_api_keys[0],
          "styles_path" => AresMUSH.website_styles_path,
          "uploads_path" => AresMUSH.website_uploads_path,
          "game_name" => Global.read_config("game", "name"),
          "use_api_proxy" => use_api_proxy,
          "use_https" => Global.read_config("server", "use_https")
        }
        
        if (!Dir.exist?(AresMUSH.website_scripts_path))
          Dir.mkdir AresMUSH.website_scripts_path
        end
        
        File.open(file_path, 'w') do |f|
          f.write "var aresconfig = #{config.to_json};"
        end
        
        Website.emoji_regex = EmojiFormatter.emoji_regex
      end
    end
  end
end