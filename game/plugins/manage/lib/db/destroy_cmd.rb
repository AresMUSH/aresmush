module AresMUSH
  module Manage
    class DestroyCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'destroy'
        }
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.name, client, enactor) do |target|
          if (!Manage.can_manage_object?(enactor, target))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          if (Rooms::Api.is_special_room?(target))
            client.emit_failure(t('manage.cannot_destroy_special_rooms'))
            return
          end
        
          if (Game.master.is_special_char?(target))
            client.emit_failure(t('manage.cannot_destroy_special_chars'))
            return
          end
          
          if (target.class == "AresMUSH::Character" && FS3Combat::Api.is_in_combat?(target))
            client.emit_failure t('manage.cannot_destroy_in_combat')
            return
          end
        
          client.program = { :destroy_target => target.id, :destroy_class => target.class }
          client.emit BorderedDisplay.text(t('manage.confirm_object_destroy', :name => target.name, :type => target.class.name.rest("::"), :dbref => target.dbref, :examine => target.print_json))
        end
      end
    end
  end
end
