module AresMUSH
  module Utils
    class ColorModeCmd
      include CommandHandler

      attr_accessor :option

      def parse_args
        arg = upcase_arg(cmd.args)
        
        if (cmd.root_is?("fansi") && arg == "ON")
          self.option = "FANSI"
        elsif (cmd.root_is?("fansi") && arg == "OFF")
          self.option = "ANSI"
        elsif arg == "ON"
          self.option = "ANSI"
        elsif arg == "OFF"
          self.option = "NONE"
        else
          self.option = arg
        end
      end
      
      def required_args
        [ self.option ]
      end
      
      def check_mode
        modes = [ "ANSI", "FANSI", "NONE" ]
        return t('ansi.invalid_color_mode', :modes => modes.join(' ')) if !modes.include?(self.option)
        return nil
      end
      
      def handle
        enactor.update(color_mode: self.option)
        client.emit_success t('ansi.color_mode_set', :option => self.option)
      end
    end
  end
end