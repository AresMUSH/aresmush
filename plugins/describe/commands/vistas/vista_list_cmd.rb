module AresMUSH

  module Describe
    class VistaListCmd
      include CommandHandler
            
      attr_accessor :target
      
      def parse_args
        self.target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.target ]
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
          
          list = model.vistas.sort.map { |name, desc| "%xh#{name}%xn%R%T#{desc}" }
          template = BorderedListTemplate.new list, t('describe.vistas_title', :name => model.name)
          client.emit template.render
        end
      end
    end
  end
end
