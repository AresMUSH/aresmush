module AresMUSH
  module Describe
    class LookCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      attr_accessor :target
            
      def initialize
        RendererFactory.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("look")
      end
      
      def crack!
        cmd.crack!(/(?<target>.+)/)
        self.target = trim_input(cmd.args.target) || 'here'
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(target, client) do |model|
          desc = Describe.get_desc(model)
          client.emit(desc)
          if (model.class == Character)
            looked_at = Global.client_monitor.find_client(model)
            if (!looked_at.nil?)
              looked_at.emit_ooc t('describe.looked_at_you', :name => client.name)
            end
          end
        end
      end      
    end
  end
end
