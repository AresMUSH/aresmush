module AresMUSH
  module Website
    class WebConfigUpdatedEventHandler
      def on_event(event)
        file_path = File.join(AresMUSH.website_scripts_path, 'config.js')

        config = {
          "port" => Global.read_config("server", "websocket_port"),
          "mu_name" => Global.read_config("game", "name"),
          "host" => Global.read_config("server", "hostname"),
        }
        
        File.open(file_path, 'w') do |f|
          f.write "var config = #{config.to_json};"
        end
        
        file_path = File.join(AresMUSH.root_path, 'Passengerfile.json')        
        config = JSON.parse(File.read(file_path))
        config['port'] = Global.read_config("server", "webserver_port")
        
        File.open(file_path, 'w') do |f|
          f.write JSON.pretty_generate(config)
        end
               
      end
    end
  end
end