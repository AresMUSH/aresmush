module AresMUSH

  module Describe
    class DetailSetCmd
      include CommandHandler
            
      attr_accessor :name, :target, :desc

      def crack!
        cmd.crack_args!(ArgParser.arg1_slash_arg2_equals_arg3)
        self.target = cmd.args.arg1
        self.name = titleize_input(cmd.args.arg2)
        self.desc = cmd.args.arg3
      end
      
      def required_args
        {
          args: [ self.target, self.desc, self.name ],
          help: 'detail'
        }
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.target, client, enactor) do |model|
                    
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          detail = model.detail(self.name)
          
          if (!detail)
            model.create_desc(:detail, self.desc, self.name)
          else
            detail.update(description: self.desc)
          end
          client.emit_success t('describe.detail_set')
        end
      end
    end
  end
end
