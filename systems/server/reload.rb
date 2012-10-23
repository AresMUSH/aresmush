module AresMUSH
  module Commands
    class Reload
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def self.name
        "Reload"
      end
      
      def handle(client, cmd)
        if cmd =~ /^reload (?<file_name>.+)/
          file_name = $~[:file_name]
          systems = Dir[File.join(Dir.pwd + "/systems/**/*.rb")]
          system_to_reload = systems.select { |f| f.end_with?("#{file_name}.rb")}
          puts system_to_reload.inspect
          if (system_to_reload.empty?)
            client.emit_failure "Can't find #{file_name} system."
          else
            client.emit_success "Reloading #{file_name} system."
            load system_to_reload[0]
          end
        end      
      end
    end
  end
end
