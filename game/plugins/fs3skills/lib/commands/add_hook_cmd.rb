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
        hook = enactor.fs3_hooks.find(name: self.name)
        if (!hook)          
          hook.update(description: self.desc)
        else
          FS3RpHook.create(name: self.name, description: self.desc, character: enactor)
        end
        client.emit_success t('fs3skills.hook_set', :name => self.name)
      end
    end
  end
end
