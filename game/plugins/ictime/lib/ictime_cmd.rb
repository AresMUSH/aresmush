module AresMUSH
  module ICTime
    class IctimeCmd
      include CommandHandler
           
      def help
        "`ictime` - Shows the IC time."
      end
      
      def handle
        client.emit_ooc ICTime.ic_long_timestr ICTime.ictime
      end
    end
  end
end
