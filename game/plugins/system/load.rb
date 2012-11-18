module AresMUSH
  module System
    class Load
      include AresMUSH::Plugin

      def after_initialize
        @plugin_manager = container.plugin_manager
      end

      def want_command?(cmd)
        cmd.root_is?("load")
      end

      def on_command(client, cmd)
        plugin_name = cmd.args
        begin
          @plugin_manager.load_plugin(plugin_name)
          client.emit_success "Reloading '#{plugin_name}' plugin."
        rescue SystemNotFoundException => e
          client.emit_failure "Can't find '#{plugin_name}' plugin."
        rescue Exception => e
          client.emit_failure "Error loading '#{plugin_name}' plugin: #{e.to_s}"
        end
        Locale.reload!
      end
    end
  end
end
