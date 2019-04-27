module AresMUSH
  module Describe
    class VistaDeleteCmd
      include CommandHandler
           
      attr_accessor :target, :name
      
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
          
          if (!model.vistas.has_key?(self.name))
            client.emit_failure t('describe.no_such_vista', :name => self.name)
            return
          end
          
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          vistas = model.vistas
          vistas.delete self.name
          model.update(vistas: vistas)
          client.emit_success t('describe.vista_deleted')
        end
      end
    end
  end
end
