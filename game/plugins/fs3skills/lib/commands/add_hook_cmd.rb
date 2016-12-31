module AresMUSH

  module FS3Skills
    class AddHookCmd
      include CommandHandler
      
      attr_accessor :name, :desc
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end

      def required_args
        {
          args: [ self.name, self.desc ],
          help: 'hooks'
        }
      end
      
      def check_name_for_dots
        return t('fs3skills.no_special_characters') if (self.name !~ /^[\w\s]+$/)
        return nil
      end
      
      def handle
        FS3Skills.set_hook(enactor, self.name, self.desc)
        client.emit_success t('fs3skills.hook_set', :name => self.name)
      end
    end
  end
end
