module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end

      def on_command(client, cmd)
        args = DescCmdCracker.crack(cmd)

        valid = DescCmdValidator.validate(args, client)
        return if !valid

        model = Rooms.find_visible_object(args.target, client) 
        return if model.nil?

        DescCmdHandler.handle(model, args.desc, client)        
      end
    end
  end
end
