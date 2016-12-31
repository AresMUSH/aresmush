module AresMUSH
  module Describe
    class DetailDeleteCmd
      include CommandHandler
           
      attr_accessor :target, :name     
      
      def crack!
        cmd.crack_args!(ArgParser.arg1_slash_arg2)
        self.target = cmd.args.arg1
        self.name = titleize_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.target, self.name ],
          help: 'detail'
        }
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
          detail = model.detail(self.name)
          
          if (!detail)
            client.emit_failure t('describe.no_such_detail', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          detail.delete
          client.emit_success t('describe.detail_deleted')
        end
      end
    end
  end
end
