module AresMUSH
  module FS3Combat
    class ArmorDetailCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'armor'
        super
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def check_armor_exists
        return t('fs3combat.invalid_armor') if !FS3Combat.armor(self.name)
        return nil
      end
      
      def handle
        list = FS3Combat.armor(self.name).sort.map { |k, v| type_display(k, v) }
        client.emit BorderedDisplay.list list, self.name
      end
        
      def type_display(name, info)
        title = t("fs3combat.armor_title_#{name}")
        detail = FS3Combat.gear_detail(info)
        "%xh#{left(title, 20)}%xn #{detail}"
      end
    end
  end
end