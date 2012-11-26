module AresMUSH
  
  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end
      
      def on_command(client, cmd)
        args = cmd.crack_args!(/(?<target>\S+)\=(?<desc>.+)/)
        
        (client.emit("You didn't supply a description!") and return) if args.nil?
        
        target = args[:target]
        desc = args[:desc]
        
        model = Room.find_visible(target, cmd.enactor) 
        if (model.empty?)
          # TODO FAIL
          client.emit_failure("Can't find #{model["name"]}.")
        elsif (model.count > 1)
          # TODO FAIL
          client.emit_failure("Can't well which #{model["name"]} you mean.")
        else
          model = model[0]
          model["desc"] = desc
          model_mod = AresMUSH.const_get(model["type"])
          model_mod.update(model)
          client.emit_success("You set the description on #{model["name"]}.")
        end
      end
    end
  end
end
