module AresMUSH
  module Describe
    class Look
      include AresMUSH::Plugin
      
      def after_initialize
        @plugin_manager = Global.plugin_manager
      end

      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("look")
      end
      
      def on_command(client, cmd)
        args = crack(cmd)
        
        # Default to 'here' if no args are specified.
        target = args.target || t('object.here')

        find_result = VisibleTargetFinder.find(target, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end

        model = find_result.target
        desc_iface = Describe.interface(@plugin_manager)

        handle(desc_iface, model, client)
      end
      
      def crack(cmd)
        cmd.crack!(/(?<target>.+)/)
        cmd.args
      end
      
      def handle(desc_iface, model, client)
        desc = desc_iface.get_desc(model)
        client.emit(desc)
      end
    end
  end
end
