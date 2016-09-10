module AresMUSH
  module Login
    class AliasCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :alias
      
      def want_command?(client, cmd)
        cmd.root_is?("alias")
      end
      
      def crack!
        self.alias = trim_input(cmd.args)
      end

      def handle
        if (self.alias.nil?)
          client.char.alias = nil
          client.char.save!
          client.emit_success t('login.alias_cleared')
          return
        end
        
        # Catch the old-school alias me=whatever
        if (self.alias.include?("="))
          self.alias = self.alias.rest("=")
        end
        
        name_validation_msg = Character.check_name(self.alias)
        if (!name_validation_msg.nil?)
          client.emit_failure(name_validation_msg)
          return
        end
        
        client.char.alias = self.alias
        client.char.save!
        client.emit_success t('login.alias_set', :alias => self.alias)
      end
    end
  end
end
