module AresMUSH
  module Describe
    class VistaEditCmd
      include CommandHandler
      
      attr_accessor :name, :target
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
      end
      
      def required_args
        [ self.target, self.name ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          if (model.class != AresMUSH::Room)
            client.emit t('describe.vistas_only_rooms')
            return
          end
          
          vista = model.vistas[self.name]
          
          
          if (!vista)
            client.emit_failure t('describe.no_such_vista', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          Utils.grab client, enactor, "vista/set #{self.target}/#{self.name}=#{vista}"
        end
      end
      
    end    
  end
end
