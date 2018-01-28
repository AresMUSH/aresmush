module AresMUSH
  module Roles
    class CharCreatedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        default_roles = Global.read_config("roles", "default_roles") || []
        default_roles.each do |role_name|
          role = Role.find_one(name: role_name)
          if (role)
            char.roles.add role
          else
            Global.logger.warn("Can't find default role #{role_name}.")
          end
        end
      end
    end
  end
end