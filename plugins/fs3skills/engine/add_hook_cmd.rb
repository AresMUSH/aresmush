module AresMUSH

  module FS3Skills
    class AddHookCmd
      include CommandHandler
      
      attr_accessor :name, :desc, :char_name
      
      def parse_args
        # Admin version
        if ((cmd.args =~ /\//) && FS3Skills.can_manage_abilities?(enactor))
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.char_name = titlecase_arg(args.arg1)
          self.name = titlecase_arg(args.arg2)
          self.desc = args.arg3
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.desc = args.arg2
          self.char_name = enactor_name
        end
        
      end

      def required_args
        [ self.char_name, self.name, self.desc ]
      end
      
      def check_name_for_dots
        return t('fs3skills.no_special_characters') if (self.name !~ /^[\w\s]+$/)
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.char_name
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end    
      
      def handle
        ClassTargetFinder.with_a_character(self.char_name, client, enactor) do |model|
          FS3Skills.set_hook(model, self.name, self.desc)
          client.emit_success t('fs3skills.hook_set', :name => self.name)
        end
      end
    end
  end
end
