module AresMUSH
  module Describe
    class Look
      include AresMUSH::Plugin
      
      def after_initialize
        @plugin_manager = container.plugin_manager
      end

      def want_command?(cmd)
        cmd.root_is?("look")
      end
      
      def on_command(client, cmd)
        args = LookCmdCracker.crack(cmd)
        
        model = LookTargetFinder.find(args, client)
        return if (model.nil?)
        
        desc_iface = Describe.interface(@plugin_manager)

        LookCmdHandler.handle(desc_iface, model, client)
      end
    end
  end
end
