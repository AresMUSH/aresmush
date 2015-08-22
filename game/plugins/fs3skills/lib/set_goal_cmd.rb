module AresMUSH

  module FS3Skills
    class SetGoalCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :add_item

      def initialize
        self.required_args = ['name']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("goal")  &&
         (cmd.switch_is?("add") || 
          cmd.switch_is?("remove"))
      end

      def crack!
        self.name = cmd.args
        self.add_item = cmd.switch_is?("add")
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(client.char)
      end
      
      def handle
        
        found = client.char.fs3_goals.select { |g| g.downcase == self.name.downcase }.first
        
        if (self.add_item)
          if (found)
            client.emit_failure t('fs3skills.item_already_selected', :name => self.name)
            return
          end
          
          client.char.fs3_goals << self.name
          client.char.save
          client.emit_success t('fs3skills.item_selected', :name => self.name)
        else
          if (!found)
            client.emit_failure t('fs3skills.item_not_selected', :name => self.name)
            return
          end
          
          client.char.fs3_goals.delete found
          client.char.save
          client.emit_success t('fs3skills.item_removed', :name => self.name)
        end
      end
    end
  end
end
