module AresMUSH

  module FS3Skills
    class AddHookCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
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
        if (enactor.hooks.has_key?(self.name))
          client.emit_failure t('fs3skills.item_already_selected', :name => self.name)
        else
          enactor.hooks[self.name] = self.desc
          enactor.save
          client.emit_success t('fs3skills.item_selected', :name => self.name)
        end
      end
    end
  end
end
