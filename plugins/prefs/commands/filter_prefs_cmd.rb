module AresMUSH
  module Prefs
    class FilterPrefsCmd
      include CommandHandler
                
      attr_accessor :category, :setting
            
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
          
        self.category = titlecase_arg(args.arg1)
        self.setting = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.category ]
      end
      
      def check_setting
        return nil if !self.setting
        return t('prefs.invalid_setting') if !Prefs.is_valid_setting?(self.setting)
        return nil
      end
      
      def handle
        
        prefs = {
          '+' => [],
          '-' => [],
          '~' => []
        }
        Chargen.approved_chars.each do |c|
          if (c.prefs && c.prefs[self.category])
            char_setting = c.prefs[self.category]['setting']
            
            if (!self.setting || self.setting == char_setting)
              prefs[char_setting] << { name: c.name, note: c.prefs[self.category]['note'] }
            end
          end
        end
        
        template = PrefsFilterTemplate.new(prefs, self.category)
        client.emit template.render
      end
    end
  end
end
