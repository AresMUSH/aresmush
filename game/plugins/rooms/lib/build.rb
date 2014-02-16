module AresMUSH
  module Rooms
    class Build
      include AresMUSH::Plugin

      def want_command?(client, cmd)
        cmd.root_is?("build")
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !client.logged_in?
        # TODO - validate args
        return nil
      end
      
      def handle
        name = cmd.args
        room = Room.create("name" => name)
        client.emit_success("You build a room named #{name}.  ID: #{room["_id"]}")
      end
    end
  end
end
