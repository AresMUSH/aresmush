module AresMUSH
  module FS3Combat
    class ArmorDetailCmd
      include CommandHandler
      include TemplateFormatters
      
      attr_accessor :name
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'armor'
        }
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