module AresMUSH
  module Manage
    class AliasCmd
      include CommandHandler
      
      attr_accessor :alias, :name
      
      def parse_args
        if (cmd.args =~ /\=/ )
          self.name = trim_arg(cmd.args.before("="))
          self.alias = trim_arg(cmd.args.after("="))
        else
          self.name = "me"
          self.alias = trim_arg(cmd.args)
        end
      end
      
      def handle
        VisibleTargetFinder.with_something_visible(self.name, client, enactor) do |target|
        
          if (!can_manage?(target))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          if (self.alias.blank?)
            target.update(alias: nil)
            client.emit_success t('manage.alias_cleared')
            return
          end
          
          if (target.class == Character)
            name_validation_msg = Character.check_name(self.alias, target)
          else
            existing_exit = enactor_room.has_exit?(self.alias)
            if (existing_exit)
              name_validation_msg = t('rooms.exit_already_exists')
            end
          end
          
          if (name_validation_msg)
            client.emit_failure(name_validation_msg)
            return
          end
    
          target.update(alias: self.alias)
          client.emit_success t('manage.alias_set', :alias => self.alias)
        end
      end
      
      def can_manage?(target)
        return true if Manage.can_manage_game?(enactor)
        
        if (target.class == Character)
          return target == enactor
        end
        
        if (target.class == Room)
          return false
        end
        
        return Manage.can_manage_object?(enactor, target)
        
      end
    end
  end
end
