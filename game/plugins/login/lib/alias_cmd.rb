module AresMUSH
  module Login
    class AliasCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :alias, :name
      
      def crack!
        if (cmd.args =~ /\=/ )
          self.name = trim_input(cmd.args.before("="))
          self.alias = trim_input(cmd.args.after("="))
        else
          self.name = "me"
          self.alias = trim_input(cmd.args)
        end
      end
      
      def handle
        char = ClassTargetFinder.find(self.name, Character, client)
        return if (!char.found?)

        target = char.target
        
        if (target == client.char || Manage::Api.can_manage_game?(client.char))
          update_alias(target)
        else
          client.emit_failure t('dispatcher.not_allowed')
        end
      end
      
      def update_alias(target)
        if (self.alias.blank?)
          target.alias = nil
          target.save!
          client.emit_success t('login.alias_cleared')
        else
          
          name_validation_msg = Character.check_name(self.alias)
          if (!name_validation_msg.nil?)
            client.emit_failure(name_validation_msg)
            return
          end
        
          target.alias = self.alias
          target.save!
          client.emit_success t('login.alias_set', :alias => self.alias)
        end
      end
    end
  end
end
