module AresMUSH

  module FS3Skills
    class RemoveHookCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'hooks'
        }
      end
      
      def handle        
        hook = enactor.fs3_hooks.find(name: self.name)
        if (!hook)          
          client.emit_failure t('fs3skills.hook_not_found', :name => self.name)
        else
          hook.delete
          client.emit_success t('fs3skills.hook_removed', :name => self.name)
        end
      end
    end
  end
end
