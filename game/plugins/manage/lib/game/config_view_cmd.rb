module AresMUSH
  module Manage
    class ConfigViewCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :section
      
      def crack!
        self.section = trim_input(cmd.args)
      end
      
      def check_section_exists
        return t('manage.invalid_config_section') if !Global.config_reader.config.has_key?(self.section)
        return nil
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end
            
      def handle
        title = t('manage.config_section', :name => self.section)
        text = PP.pp(Global.read_config(self.section), "")
        client.emit BorderedDisplay.text(text, title)
      end
    end
  end
end