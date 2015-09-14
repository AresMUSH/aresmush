module AresMUSH

  module FS3Skills
    class RemoveHashCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'goals'
        super
      end
      
      def want_command?(client, cmd)
        (cmd.root_is?("hook") ||
         cmd.root_is?("goal")) &&
         cmd.switch_is?("remove")
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        item_hash = cmd.root_is?("hook") ? client.char.hooks : client.char.goals
        
        if (item_hash.has_key?(self.name))
          item_hash.delete self.name
          client.char.save
          client.emit_success t('fs3skills.item_removed', :name => self.name)
        else
          client.emit_failure t('fs3skills.item_not_selected', :name => self.name)
        end
      end
    end
  end
end
