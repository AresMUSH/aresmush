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
        if (enactor.hooks.has_key?(self.name))
          enactor.hooks.delete self.name
          enactor.save
          client.emit_success t('fs3skills.item_removed', :name => self.name)
        else
          client.emit_failure t('fs3skills.item_not_selected', :name => self.name)
        end
      end
    end
  end
end
