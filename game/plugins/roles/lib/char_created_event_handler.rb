module AresMUSH
  module Roles
    class CharCreatedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        default_roles = Global.read_config("roles", "default_roles") || []
        default_roles.each do |role|
          char.roles.add Role.find_one(name: role)
        end
      end
    end
  end
end