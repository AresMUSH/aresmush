module AresMUSH
  module Manage
    class ConfigViewCmd
      include CommandHandler

      attr_accessor :section, :subsection
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
        self.section = downcase_arg(args.arg1)
        self.subsection = downcase_arg(args.arg2)
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
        if (self.subsection)
          title = t('manage.config_section', :name => "#{self.section}/#{self.subsection}")
          json = Global.read_config(self.section, self.subsection)
        else
          title = t('manage.config_section', :name => self.section)
          json = Global.read_config(self.section)
        end

        begin
          text = JSON.pretty_generate(json)
        rescue
          text = json
        end
        
        template = BorderedDisplayTemplate.new text, title
        client.emit template.render
      end
    end
  end
end