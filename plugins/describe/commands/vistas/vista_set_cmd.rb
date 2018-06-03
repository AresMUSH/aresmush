module AresMUSH

  module Describe
    class VistaSetCmd
      include CommandHandler
            
      attr_accessor :name, :target, :desc
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target = trim_arg(args.arg1)
        self.name = titlecase_arg(args.arg2)
        self.desc = args.arg3
      end
      
      def required_args
        [ self.target, self.desc, self.name ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|

          if (model.class != AresMUSH::Room)
            client.emit t('describe.vistas_only_rooms')
            return
          end
                              
          if (!Describe.can_describe?(enactor, model))
            client.emit_failure(t('dispatcher.not_allowed'))
            return
          end
          
          vistas = model.vistas
          vistas[self.name] = self.desc
          model.update(vistas: vistas)

          client.emit_success t('describe.vista_set')
        end
      end
    end
  end
end
