module AresMUSH
  module Login
    class ConfigUpdatedEventHandler
      def on_event(event)
        Engine.dispatcher.spawn("Getting rhost blacklist", nil) do
          Login.update_blacklist
        end
      end
    end
  end
end
