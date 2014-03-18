module AresMUSH
  module Rooms
    class BuildCmd
      include AresMUSH::Plugin

      attr_accessor :name
      
      # Validators
      must_be_logged_in
      no_switches
      
      def want_command?(client, cmd)
        cmd.root_is?("build")
      end
      
      def crack!
        self.name = cmd.args
      end

      # TODO - Validate permissions
      
      def validate_name_set
        return t('dispatcher.invalid_syntax') if self.name.nil?
        return nil
      end
      
      def handle
        room = AresMUSH::Room.create(:name => name)
        client.emit_success("You build a room named #{name}.  ID: #{room["_id"]}")
        Rooms.move_to(client, room)
        
      end
    end
  end
end
