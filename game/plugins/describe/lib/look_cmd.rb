module AresMUSH
  module Describe
    class LookCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :target

      def want_command?(client, cmd)
        cmd.root_is?("look") && cmd.args !~ /\//
      end
      
      def crack!
        self.target = trim_input(cmd.args) || 'here'
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(target, client) do |model|
          template = Describe.get_desc_template(model, client)
          template.render
          if (model.class == Character)
            looked_at = model.client
            if (!looked_at.nil?)
              looked_at.emit_ooc t('describe.looked_at_you', :name => client.name)
            end
          end
        end
      end      
    end
  end
end
