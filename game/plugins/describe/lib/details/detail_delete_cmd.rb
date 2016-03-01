module AresMUSH
  module Describe
    class DetailDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :target, :name
      
      def initialize
        self.required_args = ['name', 'target']
        self.help_topic = 'detail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("detail") && cmd.switch_is?("delete")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2)
        self.target = cmd.args.arg1
        self.name = titleize_input(cmd.args.arg2)
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client) do |model|
          if (!model.has_detail?(self.name))
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(client.char, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          model.details.delete(self.name)
          model.save!
          client.emit_success t('describe.detail_deleted')
        end
      end
    end
  end
end
