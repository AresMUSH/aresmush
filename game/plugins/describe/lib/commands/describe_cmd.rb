module AresMUSH

  module Describe
    class DescCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :target, :desc

      def initialize
        self.required_args = ['target', 'desc']
        self.help_topic = 'describe'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("describe") || cmd.root_is?("shortdesc")
      end

      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(target, client) do |model|

          if (!Describe.can_describe?(client.char, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          if (cmd.root_is?("shortdesc"))
            model.shortdesc = desc
          else
            Describe.set_desc(model, desc)
          end
          client.emit_success(t('describe.desc_set', :name => model.name))
        end
      end
        
    end
  end
end
