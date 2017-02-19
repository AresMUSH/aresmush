module AresMUSH

  module FS3Skills
    class RemoveHookCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        {
          args: [ self.name ],
          help: 'hooks'
        }
      end
      
      def handle        
        hook = enactor.fs3_hooks.find(name: self.name).first
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
