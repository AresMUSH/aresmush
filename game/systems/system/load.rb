module AresMUSH
  module EventHandlers
    class Load
      def initialize(container)
        @system_manager = container.system_manager
      end

      def commands
        ["load (?<system_name>.+)"]
      end

      def on_player_command(client, cmd)
        system_name = cmd[:system_name]
        begin
          @system_manager.load_system(system_name)
          client.emit_success "Reloading '#{system_name}' system."
        rescue SystemNotFoundException => e
          client.emit_failure "Can't find '#{system_name}' system."
        rescue Exception => e
          client.emit_failure "Error loading '#{system_name}' system: #{e.to_s}"
        end
      end
    end
  end
end
