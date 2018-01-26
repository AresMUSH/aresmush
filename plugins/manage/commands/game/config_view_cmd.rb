module AresMUSH
  module Manage
    class ConfigViewCmd
      include CommandHandler

      attr_accessor :section
      
      def parse_args
        self.section = trim_arg(cmd.args)
      end
      
      def check_section_exists
        return t('manage.invalid_config_section') if !Global.config_reader.config.has_key?(self.section)
        return nil
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
            
      def handle
        title = t('manage.config_section', :name => self.section)
        json = Global.read_config(self.section)

        template = BorderedDisplayTemplate.new JSON.pretty_generate(json), title
        client.emit template.render
      end
    end
  end
end