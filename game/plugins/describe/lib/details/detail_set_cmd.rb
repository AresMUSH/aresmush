module AresMUSH

  module Describe
    class DetailSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      include CommandRequiresArgs
      
      attr_accessor :name, :target, :desc
      
      def initialize
        self.required_args = ['name', 'target', 'desc']
        self.help_topic = 'detail'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2_equals_arg3)
        self.target = cmd.args.arg1
        self.name = titleize_input(cmd.args.arg2)
        self.desc = cmd.args.arg3
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client) do |model|
          
          if (!Describe.can_describe?(client.char, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          model.details[self.name] = self.desc
          model.save
          client.emit_success t('describe.detail_set')
        end
      end
    end
  end
end
