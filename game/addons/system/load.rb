module AresMUSH
  module System
    class Load
      include AresMUSH::Addon

      def after_initialize
        @addon_manager = container.addon_manager
      end

      def want_command?(cmd)
        cmd.root_is?("load")
      end

      def on_command(client, cmd)
        addon_name = cmd.args
        begin
          @addon_manager.load_addon(addon_name)
          client.emit_success "Reloading '#{addon_name}' addon."
        rescue SystemNotFoundException => e
          client.emit_failure "Can't find '#{addon_name}' addon."
        rescue Exception => e
          client.emit_failure "Error loading '#{addon_name}' addon: #{e.to_s}"
        end
        Locale.reload!
      end
    end
  end
end
