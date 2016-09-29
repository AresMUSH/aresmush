module AresMUSH
  module FS3Combat
    class WeaponDetailCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name']
        self.help_topic = 'weapons'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_weapon_exists
        return t('fs3combat.invalid_weapon') if !FS3Combat.weapon(self.name)
        return nil
      end
      
      def handle
        template = GearDetailTemplate.new(FS3Combat.weapon(self.name), self.name)
        client.emit template.render
      end
    end
  end
end