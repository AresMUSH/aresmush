module AresMUSH
  module Groups
    class GroupSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :value, :group_name

      def initialize
        self.required_args = ['name', 'group_name']
        self.help_topic = 'groups'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("group") && cmd.switch_is?("set")
      end
      
      def crack!
        if (cmd.args =~ /\//)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_optional_arg3)
          self.name = titleize_input(cmd.args.arg1)
          self.group_name = titleize_input(cmd.args.arg2)
          self.value = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
          self.name = client.name
          self.group_name = titleize_input(cmd.args.arg1)
          self.value = titleize_input(cmd.args.arg2)
        end
      end
      
      def check_can_set
        return nil if self.name == client.name
        return nil if Groups.can_set_group?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def check_chargen_locked
        return nil if Groups.can_set_group?(client.char)
        Chargen::Interface.check_chargen_locked(client.char)
      end
      
      def handle   
        group = Groups.get_group(self.group_name)
        
        if (group.nil?)
          client.emit_failure t('groups.invalid_group_type')
          return
        end
        
        values = group['values']
        if (!self.value.nil? && !values.nil?)
          self.value = values.keys.find { |v| v.downcase == self.value.downcase }
          if (self.value.nil?)
            client.emit_failure t('groups.invalid_group_value', :group => self.group_name)
            return
          end
        end
        
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          model.groups[self.group_name] = self.value
          model.save
          
          if (self.value.nil?)
            client.emit_success t('groups.group_cleared', :group => self.group_name)
          else
            client.emit_success t('groups.group_set', :group => self.group_name, :value => self.value)
            client.emit_ooc t('groups.group_skill_notice')
          end
        end
      end
    end
  end
end
