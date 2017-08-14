module AresMUSH
  module Login
    class AliasCmd
      include CommandHandler
      
      attr_accessor :alias, :name
      
      def help
        "`alias <name>` - Sets your alias.  Leave blank to clear it."
      end
      
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
        char = ClassTargetFinder.find(self.name, Character, enactor)
        return if (!char.found?)

        target = char.target
        
        if (target == enactor || enactor.can_manage_game?)
          update_alias(target)
        else
          client.emit_failure t('dispatcher.not_allowed')
        end
      end
      
      def update_alias(target)
        if (self.alias.blank?)
          target.update(alias: nil)
          client.emit_success t('login.alias_cleared')
        else
          
          name_validation_msg = Character.check_name(self.alias)
          if (name_validation_msg)
            client.emit_failure(name_validation_msg)
            return
          end
        
          target.update(alias: self.alias)
          client.emit_success t('login.alias_set', :alias => self.alias)
        end
      end
    end
  end
end
