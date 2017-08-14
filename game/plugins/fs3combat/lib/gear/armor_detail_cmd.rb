module AresMUSH
  module FS3Combat
    class ArmorDetailCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_armor_exists
        return t('fs3combat.invalid_armor') if !FS3Combat.armor(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.armor(self.name), self.name, :armor)
        client.emit template.render
      end
    end
  end
end