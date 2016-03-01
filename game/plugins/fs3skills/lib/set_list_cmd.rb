module AresMUSH

  module FS3Skills
    class SetListCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :add_item, :item_type

      def initialize
        self.required_args = ['name']
        self.help_topic = 'abilities'
        super
      end
      
      def want_command?(client, cmd)
        (cmd.root_is?("language") ||
         cmd.root_is?("interest") ||
         cmd.root_is?("expertise")) &&
         (cmd.switch_is?("add") || 
          cmd.switch_is?("remove"))
      end

      def crack!
        self.item_type = cmd.root.downcase.to_sym
        self.name = titleize_input(cmd.args)
        self.add_item = cmd.switch_is?("add")
      end
      
      def check_name
        ability_type = FS3Skills.get_ability_type(client.char, self.name)
        invalid_types = [:action, :advantage, :aptitude]
        return t('fs3skills.cant_overlap_with_name') if invalid_types.include?(ability_type)
        return nil
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(client.char)
      end
      
      def handle
        if (self.add_item)
          if (FS3Skills.add_unrated_ability(client, client.char, self.name, self.item_type))
            client.char.save
          end
        else
          list = FS3Skills.get_ability_list_for_type(client.char, self.item_type)
          
          if (!list.include?(self.name))
            client.emit_failure t('fs3skills.item_not_selected', :name => self.name)
            return
          end
          list.delete self.name
          
          client.char.save
          client.emit_success t('fs3skills.item_removed', :name => self.name)
        end
      end
    end
  end
end
