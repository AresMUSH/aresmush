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
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
        self.target = trim_input(cmd.args.target)
        self.desc = cmd.args.desc
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(target, client) do |model|

          if (!Describe.can_describe?(client, model))
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
