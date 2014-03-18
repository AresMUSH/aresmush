module AresMUSH
  module Rooms
    class GoCommand
      include AresMUSH::Plugin

      attr_accessor :destination
      
      # Validators
      must_be_logged_in
      no_switches
      
      def want_command?(client, cmd)
        cmd.root_is?("go")
      end
      
      def crack!
        self.destination = trim_input(cmd.args)
      end
      
      def validate_destination
        return t('dispatcher.invalid_syntax') if self.destination.nil?
        return nil
      end
      
      # TODO - Permissions
      
      def handle
        find_result = SingleTargetFinder.find(self.destination, Room)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        Rooms.move_to(client, find_result.target)
      end
    end
  end
end
