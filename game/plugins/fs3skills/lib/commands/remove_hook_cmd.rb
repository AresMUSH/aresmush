module AresMUSH

  module FS3Skills
    class RemoveHookCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name

      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'goals'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
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
