module AresMUSH
  module Roles
    class CharCreatedEventHandler
      def on_event(event)
        default_roles = Global.read_config("roles", "default_roles") || []
        default_roles.each do |role|
          event.char.roles.add Role.find_one(name: role)
        end
        event.char.save
      end
    end
  end
end