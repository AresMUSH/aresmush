module AresMUSH
  module Describe
    class Look
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("look")
      end
      
      def on_command(client, cmd)
        if (cmd.args.nil?)
          target = t("object.here")
        else 
          args = cmd.crack_args!(/(?<target>.+)/)
          target = args[:target]
        end
        
        model = Rooms.find_visible_object(target, client) 
        return if (model.nil?)
        
        desc = Describe.get_desc(model)
        client.emit(desc)
      end
    end
  end
end
