module AresMUSH
  module Demographics
    class GroupSetCmd
      include CommandHandler
      
      attr_accessor :name, :value, :group_name
      
      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
          self.name = titlecase_arg(args.arg1)
          self.group_name = titlecase_arg(args.arg2)
          self.value = titlecase_arg(args.arg3)
        else
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = enactor_name
          self.group_name = titlecase_arg(args.arg1)
          self.value = titlecase_arg(args.arg2)
        end
      end

      def required_args
        [ self.name, self.group_name ]
      end
      
      def check_can_set
        return nil if self.name == enactor_name
        return nil if Demographics.can_set_group?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def check_chargen_locked
        return nil if Demographics.can_set_group?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle   
        group = Demographics.get_group(self.group_name)
        
        if (!group)
          client.emit_failure t('demographics.invalid_group_type')
          return
        end
        
        values = group['values']
        if (self.value && values)
          self.value = values.keys.find { |v| v.downcase == self.value.downcase }
          if (!self.value)
            client.emit_failure t('demographics.invalid_group', :group => self.group_name)
            return
          end
        end
        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          Demographics.set_group(model, self.group_name, self.value)
                    
          if (!self.value)
            client.emit_success t('demographics.group_cleared', :group => self.group_name)
          else
            client.emit_success t('demographics.group_set', :group => self.group_name, :value => self.value)
          end
        end
      end
    end
  end
end
