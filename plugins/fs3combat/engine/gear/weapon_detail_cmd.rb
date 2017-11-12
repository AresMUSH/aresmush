module AresMUSH
  module FS3Combat
    class WeaponDetailCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def check_weapon_exists
        return t('fs3combat.invalid_weapon') if !FS3Combat.weapon(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.weapon(self.name), self.name, :weapon)
        client.emit template.render
      end
    end
  end
end