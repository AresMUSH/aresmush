module AresMUSH

  module FS3Skills
    class AddHashCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :desc

      def initialize
        self.required_args = ['name', 'desc']
        self.help_topic = 'goals'
        super
      end
      
      def want_command?(client, cmd)
        (cmd.root_is?("hook") ||
         cmd.root_is?("goal")) &&
         cmd.switch_is?("add")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.desc = cmd.args.arg2
      end
      
      def check_name_for_dots
        return t('fs3skills.no_special_characters') if (self.name !~ /^[\w\s]+$/)
        return nil
      end
      
      def handle
        item_hash = cmd.root_is?("hook") ? client.char.hooks : client.char.goals
        
        if (item_hash.has_key?(self.name))
          client.emit_failure t('fs3skills.item_already_selected', :name => self.name)
        else
          item_hash[self.name] = self.desc
          client.char.save
          client.emit_success t('fs3skills.item_selected', :name => self.name)
        end
      end
    end
  end
end
