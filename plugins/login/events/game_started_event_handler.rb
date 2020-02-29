module AresMUSH
  module Login
    class GameStartedEventHandler
      def on_event(event)
        Global.dispatcher.spawn("Getting rhost blacklist", nil) do
          Login.update_blacklist
        end
      end
    end
  end
end
