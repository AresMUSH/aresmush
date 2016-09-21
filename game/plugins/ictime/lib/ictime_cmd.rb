module AresMUSH
  module ICTime
    class ICTimeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs
           
      def handle
        time = ICTime.ic_long_timestr ICTime.ictime
        client.emit BorderedDisplay.text t('ictime.ictime', :time => time)
      end
    end
  end
end
