module AresMUSH

  module FS3Skills
    class WipeAbilityCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def check_can_set
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        FS3ActionSkill.all.each do |a|
          delete_ability(a)
        end
        FS3Language.all.each do |a|
          delete_ability(a)
        end
        FS3BackgroundSkill.all.each do |a|
          delete_ability(a)
        end
        FS3Advantage.all.each do |a|
          delete_ability(a)
        end
        FS3Attribute.all.each do |a|
          delete_ability(a)
        end
        
      end
      
      def delete_ability(ability)
        if (ability.name == self.name)
          client.emit "Deleting #{ability.character.name}'s #{ability.class} #{ability.name} -- was at rating #{ability.rating}."
          ability.delete
        end
      end

    end
  end
end
