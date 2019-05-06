module AresMUSH
  module Prefs
    class SetPrefsCmd
      include CommandHandler
                
      attr_accessor :category, :setting, :note
            
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
          
        self.category = titlecase_arg(args.arg1)
        self.setting = trim_arg(args.arg2)
        self.note = args.arg3
      end
      
      def required_args
        [ self.category ]
      end
      
      def check_setting
        return nil if !self.setting
        return t('prefs.invalid_setting') if !Prefs.is_valid_setting?(self.setting)
        return nil
      end
      
      def check_category
        cats = Prefs.categories
        return t('prefs.invalid_category', :cats => cats.join(' ')) if !cats.include?(self.category)
        return nil
      end
      
      def handle
        prefs = enactor.prefs || {}
        if (self.setting)
          prefs[self.category] = { setting: self.setting, note: self.note }
          enactor.update(prefs: prefs)
          client.emit_success t('prefs.pref_set')
        else
          prefs.delete self.category
          enactor.update(prefs: prefs)
          client.emit_success t('prefs.pref_removed')
        end
      end
    end
  end
end
