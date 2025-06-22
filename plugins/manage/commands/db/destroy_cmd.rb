module AresMUSH
  module Manage
    class DestroyCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.name, client, enactor) do |target|
          if (!Manage.can_manage_object?(enactor, target))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          if (Rooms.is_special_room?(target))
            client.emit_failure(t('manage.cannot_destroy_special_rooms'))
            return
          end
        
          if (Game.master.is_special_char?(target))
            client.emit_failure(t('manage.cannot_destroy_special_chars'))
            return
          end
                    
          client.program = { :destroy_target => target.dbref, :destroy_class => target.class }
          text = t('manage.confirm_object_destroy', :name => target.name, 
              :type => target.class.name.rest("::"), 
              :dbref => target.dbref, 
              :examine => target.print_json)

          template = BorderedDisplayTemplate.new text
          client.emit template.render
          
        end
      end
    end
  end
end
