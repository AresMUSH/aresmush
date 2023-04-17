module AresMUSH

  module FS3Skills
    class RenameAbilityCmd
      include CommandHandler

      attr_accessor :old_name, :new_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.old_name = args.arg1
        self.new_name = args.arg2
      end
      
      def required_args
        [ self.old_name, self.new_name ]
      end
      
      def check_can_set
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        FS3ActionSkill.all.each do |a|
          rename_ability(a)
        end
        FS3Language.all.each do |a|
          rename_ability(a)
        end
        FS3BackgroundSkill.all.each do |a|
          rename_ability(a)
        end
        FS3Advantage.all.each do |a|
          rename_ability(a)
        end
        FS3Attribute.all.each do |a|
          rename_ability(a)
        end
        
      end
      
      def rename_ability(ability)
        if (ability.name == self.old_name)
          ability.update(name: self.new_name)
          client.emit "Renaming #{ability.character.name}'s #{ability.class} #{self.old_name} ability to #{self.new_name}."
        end
      end

    end
  end
end
